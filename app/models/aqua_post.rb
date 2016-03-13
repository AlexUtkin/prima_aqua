class AquaPost < ActiveRecord::Base
  belongs_to :aqua
  mount_uploader :image, ImageUploader
  mount_uploader :button_image, AquaPostUploader

  default_scope -> { order(position: :asc) }
end
