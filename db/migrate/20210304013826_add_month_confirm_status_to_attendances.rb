class AddMonthConfirmStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :month_confirm_status, :integer
  end
end
