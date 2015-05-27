class PageContent < ActiveRecord::Base
  mount_uploader :main_image, ImageUploader

  enum relation: [:service, :other]
end
