class PageContent < ActiveRecord::Base
  NAMES = [:service, :partners, :collaboration, :payment, :delivery]

  mount_uploader :image, ImageUploader

  NAMES.each do |relation|
    define_singleton_method(relation) do
      find_by(relation: relation)
    end
  end
end
