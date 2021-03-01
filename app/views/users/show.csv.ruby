require 'csv'

CSV.generate do |csv|
  column_names = %w(日付 出社(H) 出社(M) 退社(H) 退社(M))
  csv << column_names
  @dates.each do |day|
    column_values = [
      day.worked_on.to_s(:date),
      if day.started_at
        day.started_at.to_s(:hour)
      end,
      if day.started_at
        day.started_at.to_s(:min)
      end,
      if day.finished_at
        day.finished_at.to_s(:hour)
      end,
      if day.finished_at
        day.finished_at.to_s(:min)
      end
    ]
    csv << column_values
  end
end
