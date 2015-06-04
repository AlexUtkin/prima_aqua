class Stand < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
