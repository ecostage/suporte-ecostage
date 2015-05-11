class Channels::TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy,
                                    :approve, :reprove, :done, :cancel]
  before_action :set_channel
  after_action :verify_authorized, except: [:show, :new_comment]
  respond_to :html, :json

  # GET /tickets
  def index
    authorize @channel, :show?
    @tickets = TicketPolicy::Scope.new(current_user, @channel.tickets).
      resolve.
      default_search(params[:search], params[:status]).
      page(params[:page]).per(params[:per] || 200)
    respond_with(@channel, @tickets)
  end

  # GET /tickets/1
  def show
    authorize @ticket, :show?

    if @ticket.unread? and !current_user.client?
      @ticket.in_progress!
      @ticket.update attended_at: DateTime.now
    end
    respond_with(@channel, @ticket)
  end

  # GET /tickets/new
  def new
    @ticket = Ticket.new
    authorize @ticket
    respond_with(@channel, @ticket)
  end

  # GET /tickets/1/edit
  def edit
    authorize @ticket
    respond_with(@channel, @ticket)
  end

  # POST /tickets
  def create
    authorize Ticket
    @ticket = Ticket.new(ticket_params)
    @ticket.channel = @channel
    @ticket.created_by = current_user
    if @ticket.save
      Notification.create(notifiable: @ticket, created_by: current_user,
                          action: :created).deliver
    end
    respond_with(@channel, @ticket)
  end

  # PATCH/PUT /tickets/1
  def update
    authorize @ticket
    @ticket.update(ticket_params)
    respond_with(@channel, @ticket)
  end

  # DELETE /tickets/1
  def destroy
    authorize @ticket
    @ticket.destroy
    respond_with(@channel, @ticket)
  end

  def approve
    authorize @ticket
    if @ticket.approved_by(current_user)
      head 204
    else
      render json: I18n.t('notification.server.internal_error').to_json, status: :internal_server_error
    end
  end

  def reprove
    authorize @ticket
    if @ticket.reproved_by(current_user)
      head 204
    else
      render json: I18n.t('notification.server.internal_error').to_json, status: :internal_server_error
    end
  end

  def done
    authorize @ticket
    if @ticket.done_by(current_user)
      head 204
    else
      render json: I18n.t('notification.server.internal_error').to_json, status: :internal_server_error
    end
  end

  def cancel
    authorize @ticket
    if @ticket.cancelled_by(current_user, params[:reason])
      head 204
    else
      render json: I18n.t('notifications.ticket.errors.cancel').to_json, status: :unprocessable_entity
    end
  end

  def new_comment
    @ticket = Ticket.find(params[:ticket_id])
    @ticket.update(params_new_comment)
    emails = if @ticket.comments.last.author.client?
      User.attendant.pluck(:email)
    else
      [@ticket.created_by.email]
    end
    CommentNotificationMailer.notify(emails, @ticket.comments.last).deliver

    redirect_to channel_ticket_path(channel_id: @channel, id: @ticket)
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def set_channel
    @channel = Channel.find params[:channel_id]
  end

  # Only allow a trusted parameter "white list" through.
  def ticket_params
    params.require(:ticket).permit(:subject, :content, :is_priority,
                                   :estimated_time, :assign_to_id, :complexity, :attachment)
  end

  def params_new_comment
    params.require(:ticket).permit(comments_attributes: [:content, :attachment]).tap do |whitelisted|
      whitelisted[:comments_attributes]['0'][:author_id] = current_user.id
    end
  end
end
