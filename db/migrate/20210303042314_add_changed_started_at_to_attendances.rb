class AddChangedStartedAtToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :changed_started_at, :datetime
  end
end
