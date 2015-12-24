class Product < ActiveRecord::Base
  include Sitemapable

  mount_uploader :image, ImageUploader

  belongs_to :category

end
