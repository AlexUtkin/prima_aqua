# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :small do
    process resize_to_limit: [200, 200]
  end

  version :one_cooler, :if => :is_cooler? do
    process resize_to_fill: [100, 100]
  end

  version :one_cooler_main, :if => :is_cooler? do
    process resize_to_limit: [400, 400]
  end

  version :for_index, :if => :is_product? do
    process resize_to_limit: [280, 200]
  end

  version :background, :if => :is_post? do
    process resize_to_fill: [1366, 768]
    process quality: 60
  end

  version :order_small, :if => :is_product? do
    process resize_to_limit: [140, 140]
  end

  version :medium, :if => :is_promo? do
    process resize_to_limit: [1000, 1000]
  end

  version :for_page, if: :is_page? do
    process resize_to_limit: [210, 210]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private
  def is_promo? picture
    model.is_a? Article
  end
  def is_page? picture
    model.is_a? PageContent
  end
  def is_cooler? picture
    model.is_a? Image
  end

  def is_volume? picture
    model.is_a? Volume
  end

  def is_post? picture
    ['AquaPost', 'CompanyPost'].include? model.class.name
  end

  def is_product? picture
    model.is_a?(Image) || model.is_a?(Pomp) || model.is_a?(Accessory) || model.is_a?(Product) || model.is_a?(Stand)
  end

end
