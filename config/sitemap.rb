require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://prima-aqua.ru'

SitemapGenerator::Sitemap.create do
  add root_path

  Aqua.find_each do |aqua|
    add aqua_path(id: aqua.id), lastmod: aqua.try(:updated_at)
  end

  Cooler.find_each do |cooler|
    add cooler_path(id: cooler.id), lastmod: cooler.try(:updated_at)
  end

  add events_path, lastmod: Article.order(:updated_at).last.try(:updated_at)
  Article.find_each do |event|
    add events_show_path(id: event.id), lastmod: event.try(:updated_at)
  end

  add pomps_path, lastmod: Pomp.order(:updated_at).last.try(:updated_at)
  add stands_path, lastmod: Stand.order(:updated_at).last.try(:updated_at)
  add accessories_path, lastmod: Accessory.order(:updated_at).last.try(:updated_at)

  add products_path(type: 'cup'), lastmod: Category.find_by_slug('cup').products.order(:updated_at).last.try(:updated_at) if Category.find_by_slug('cup').try(:products)
  add products_path(type: 'plate'), lastmod: Category.find_by_slug('plate').products.order(:updated_at).last.try(:updated_at) if Category.find_by_slug('plate').try(:products)
  add products_path(type: 'others'), lastmod: Category.find_by_slug('others').products.order(:updated_at).last.try(:updated_at) if Category.find_by_slug('others').try(:products)
  add products_path(type: 'tea'), lastmod: Category.find_by_slug('tea').products.order(:updated_at).last.try(:updated_at) if Category.find_by_slug('tea').try(:products)
  add products_path(type: 'coffee'), lastmod: Category.find_by_slug('coffee').products.order(:updated_at).last.try(:updated_at) if Category.find_by_slug('coffee').try(:products)

  add about_path, lastmod: DateTime.now
  add contacts_path, lastmod: DateTime.now
  add page_content_path(:payment), lastmod: DateTime.now
  add delivery_path, lastmod: DateTime.now
end
