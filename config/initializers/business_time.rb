BusinessTime::Config.beginning_of_workday = "9 am"
BusinessTime::Config.end_of_workday = "6 pm"

Holidays.between(5.years.ago, 1.years.from_now, :br, :observed).map do |holiday|
  BusinessTime::Config.holidays << holiday[:date]
  BusinessTime::Config.holidays << holiday[:date].next_week if !holiday[:date].weekday?
end

