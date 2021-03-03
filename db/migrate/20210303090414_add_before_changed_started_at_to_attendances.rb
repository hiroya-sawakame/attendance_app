class AddBeforeChangedStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :before_changed_started_at, :datetime
  end
end
