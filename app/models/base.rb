class Base < ApplicationRecord
  # 下記の行がないとtypeというカラム名はエラーになる
  self.inheritance_column = :_type_disabled
  mount_uploader :image, ImageUploader
end
