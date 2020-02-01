class AddContentToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :content, :string
  end
end
