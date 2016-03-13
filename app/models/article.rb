class Article < ActiveRecord::Base
  include Sitemapable

  self.inheritance_column = nil
  mount_uploader :image, ImageUploader
  mount_uploader :preview_image, PreviewImageUploader
end
