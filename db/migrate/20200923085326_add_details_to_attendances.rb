class AddDetailsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :change_start, :datetime
    add_column :attendances, :change_finished, :datetime
  end
end
