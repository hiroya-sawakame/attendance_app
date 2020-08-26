class AddDayStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :day_status, :integer
  end
end
