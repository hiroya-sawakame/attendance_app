class AddImageToBases < ActiveRecord::Migration[5.1]
  def change
    add_column :bases, :image, :string
  end
end
