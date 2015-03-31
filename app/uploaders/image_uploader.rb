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

  version :small, :if => :is_volume? do
    process resize_to_fill: [124, 200]
    end

  version :for_index, :if => :is_cooler? do
    process resize_to_fill: [280, 200]
  end

  version :background, :if => :is_post? do
    process resize_to_fill: [1366, 768]
    process quality: 60
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

  def is_volume? picture
    model.is_a? Volume
  end

  def is_post? picture
    ['AquaPost', 'CompanyPost'].include? model.class.name
  end

  def is_cooler? picture
    model.is_a? Cooler
  end

end
