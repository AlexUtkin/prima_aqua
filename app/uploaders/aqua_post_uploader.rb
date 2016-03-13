# encoding: utf-8

class AquaPostUploader < CarrierWave::Uploader::Base

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

  version :button_image_square, if: :for_button_image? do
    process resize_to_limit: [24, 24]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  private

  def for_button_image? picture
    mounted_as == :button_image
  end
end
