class Stand < ActiveRecord::Base
  include Sitemapable

  mount_uploader :image, ImageUploader
end
