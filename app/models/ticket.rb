class Ticket < ActiveRecord::Base
  include Notifiable
  include PgSearch

  pg_search_scope :search_full_text, :against => {
    :subject => 'A',
    :content => 'C'
  },
  :associated_against => {
    :created_by => { :email => 'B', name: 'B' }
  },
  :ignoring => :accents, :using => [:tsearch, :trigram, :dmetaphone]

  belongs_to :created_by, class: User
  belongs_to :assign_to, class: User
  belongs_to :channel

  has_many :comments
  accepts_nested_attributes_for :comments

  validates_presence_of :subject
  validates_presence_of :content
  validates_presence_of :created_by, associated: true
  validates_length_of :subject, maximum: 254

  before_save :set_hours_taken, unless: ->(ticket) { ticket.hours_taken && ticket.resolved_at }

  enum status: [:unread, :reproved, :in_progress, :done, :approved, :canceled]

  has_attached_file :attachment, styles: {
    thumb: '100x100#'
  }, :size => { :in => 0..25.megabytes }, :s3_permissions => :private

  validates_attachment_content_type :attachment, :content_type => [/\Aimage\/.*\Z/, /\Aapplication\/.*\Z/, /\Atext\/.*\Z/]

  recipients_for(:created) { User.attendant }
  recipients_for(:approved) { [assign_to] }
  recipients_for(:reproved) { [assign_to] }
  recipients_for(:done) { [created_by] }
  recipients_for(:canceled) { [created_by] }
  recipients_for(:assigned) { [assign_to] }

  context_for :created, :default_notification_context
  context_for :approved, :default_notification_context
  context_for :reproved, :default_notification_context
  context_for :done, :default_notification_context
  context_for :canceled, :default_notification_context
  context_for :assigned, :default_notification_context

  scope :solved, -> { where.not(resolved_at: nil) }
  scope :attended, -> { where.not(attended_at: nil) }

  scope :user_scope, -> (user) {
    if user.client?
      where(created_by: user.siblings.to_a)
    else
      all
    end
  }

  scope :default_search, -> (search, status=nil) {
    unless status.present?
      query_statuses = [statuses[:unread], statuses[:reproved],
        statuses[:in_progress], statuses[:done]]
    else
      query_statuses = statuses[status.to_sym]
    end
    query = where(status: query_statuses)

    if search.present?
      query.search_full_text(search)
    else
      query
    end
  }

  scope :apply_sort, -> {
    all.sort_by do |o|
      [Ticket.statuses[o.status], (o.is_priority ? -1 : 1),
        -o.sla, o.updated_at, o.subject]
    end
  }

  scope :recently_first, -> {
    order :updated_at=>:desc
  }

  scope :latest, -> {
    where(created_at: 1.month.ago)
  }

  after_find :auto_approve!

  def self.average_hours_taken
    average(:hours_taken)
  end

  def auto_approve!
    TicketAutoApproval.new(self).auto_approve!
  end

  def old?
    (updated_at - 15.days.ago) < 0
  end

  def default_notification_context
    {
      ticket: subject,
      channel: channel.try(:name_with_hashtag),
      assigned_to: assign_to.try(:email)
    }
  end

  def self.statuses_color
    #TODO: transfer to yml
    {
      :unread=>'#b0d8dd',
      :in_progress=>'#1674b3',
      :done=>'#ffca16',
      :approved=>'#298d10',
      :reproved=>'#b31200',
      :canceled=>'#420000'
    }.with_indifferent_access
  end

  def sla_points
    5 #TODO: configurable
  end

  def set_hours_taken
    created_at = self.created_at || DateTime.current.to_time
    resolved_at = self.resolved_at || DateTime.current.to_time
    self.hours_taken = (created_at.business_time_until(resolved_at) / 1.hour).ceil
  end

  def sla
    if canceled?
      return 0
    end

    if exceeded_estimation?
      sla_points
    else
      (sla_points*(hours_taken/estimated_time.to_f)).ceil
    end
  end

  def estimated_time
    super || 4 #TODO: Make it configurable
  end

  def exceeded_estimation?
    hours_taken >= estimated_time
  end

  def status_humanized
    Ticket.humanize_status(status)
  end

  def self.humanize_status(status)
    I18n.translate("ticket.statuses.#{status}")
  end

  def approved_by(user)
    approved!
    Notification.create(notifiable: self, created_by: user, action: :approved).
      deliver
  end

  def reproved_by(user)
    reproved!
    Notification.create(notifiable: self, created_by: user, action: :reproved).
      deliver
  end

  def done_by(user)
    done!
    update(resolved_at: DateTime.current)
    Notification.create(notifiable: self, created_by: user, action: :done).
      deliver
  end

  def cancelled_by(user, reason)
    unless reason.nil? || reason.empty?
      update(cancel_reason: reason)
      self.canceled!
      Notification.create(notifiable: self, created_by: user, action: :canceled).
        deliver
    end
  end
end
