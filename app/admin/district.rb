ActiveAdmin.register District do
  permit_params :name, :popup, :str, :lat, :lon, :map_popup, :description
  form do |f|
    f.semantic_errors
    [:name, :str, :lat, :lon, :map_popup].each do |param|
      inputs "#{param.capitalize}" do
        input param, label: false
      end
    end
    inputs 'Popup' do
      input :popup, as: :ckeditor, label: false
    end
    inputs 'Description' do
      input :description, as: :ckeditor, label: false
    end
    actions
  end
end
