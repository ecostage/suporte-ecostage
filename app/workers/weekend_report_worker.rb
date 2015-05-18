class WeekendReportWorker
  include SuckerPunch::Job
  include FistOfFury::Recurrent

  recurs { weekly.day_of_week(:friday).hour_of_day(12) }

  def perform
    Rails.logger.info 'Sending weekly ticket report'
    ReportMailer.weekend_report(Date.today).deliver
  end
end
