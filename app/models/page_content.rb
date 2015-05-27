class PageContent < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  enum relation: [:service, :other]
end
