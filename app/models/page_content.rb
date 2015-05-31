class PageContent < ActiveRecord::Base
  enum relation: [:service, :other]

  mount_uploader :image, ImageUploader

  scope :service, -> { find_by(relation: relations[:service]) }
end
