class AddBeforeChangedFinishedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_changed_finished_at, :datetime
  end
end
