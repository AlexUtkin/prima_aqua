ActiveAdmin.register PageContent do
  permit_params :relation, :main_header, :main_text, :image,
  :additional_header, :additional_text, :seo_title, :seo_description, :seo_keywords

  form partial: 'admin/page_contents/form'

end
