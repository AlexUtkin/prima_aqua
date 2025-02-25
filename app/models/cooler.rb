class Cooler < ActiveRecord::Base
  include Sitemapable

  has_and_belongs_to_many :tags
  has_many :images, as: :imageable, dependent: :destroy

  def has_tag?(name)
    tags.where(name: name).any?
  end

  def image_url(version)
    images.first.name_url(version) if images.first.present?
  end

  def type
    'Кулер'
  end
end
