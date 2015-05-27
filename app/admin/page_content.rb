ActiveAdmin.register PageContent do
  permit_params :relation, :main_header, :main_text, :image,
  :additional_header, :additional_text, :seo_title, :seo_description, :seo_keywords

  form do |f|
    f.semantic_errors
    inputs 'Relation' do
      input :relation, as: :select, collection: PageContent.relations.keys, label: false
    end
    inputs 'Main header' do
      input :main_header, label: false
    end
    inputs 'Main text' do
      input :main_text, as: :ckeditor, label: false
    end
    inputs 'Image' do
      file_field :image, label: false
    end
    inputs 'Additional header' do
      input :additional_header, label: false
    end
    inputs 'Additional text' do
      input :additional_text, as: :ckeditor, label: false
    end
    [:seo_title, :seo_description, :seo_keywords].each do |param|
      inputs "#{param.capitalize}" do
        input param, label: false
      end
    end
    actions
  end

end
