require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 曜日 出社 退社)
  csv << column_names
  @dates.each do |day|
    column_values = [
      l(day.worked_on, format: :short),
      "（#{$days_of_the_week[day.worked_on.wday]}）",
      if day.started_at
        l(day.started_at, format: :time)
      else
        "--:--"
      end,
      if day.finished_at
        l(day.finished_at, format: :time)
      else
        "--:--"
      end
    ]
    csv << column_values
  end
end
