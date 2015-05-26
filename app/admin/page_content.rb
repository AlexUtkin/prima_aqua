ActiveAdmin.register PageContent do
  permit_params :relation, :main_header, :main_text, :main_image,
  :additional_header, :additional_text, :seo_title, :seo_description, :seo_keywords
end
