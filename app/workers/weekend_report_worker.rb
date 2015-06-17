class WeekendReportWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { weekly.day(:friday).hour_of_day(12) }

  def perform
    Rails.logger.info 'Sending weekly ticket report'
    ReportMailer.weekend_report(Date.today).deliver
  end
end
