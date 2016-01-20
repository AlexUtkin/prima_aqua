ActiveAdmin.register Product do
  form partial: 'admin/products/form'

  index do
    selectable_column
    column :id
    column :title
    column :image
    column :price
    column :position
    column :seo_title
    column :seo_description
    column :seo_keywords
    actions
  end

  show do |product|
    attributes_table do
      row :title
      row :price
      row :position
      row :seo_title
      row :seo_description
      row :seo_keywords
      row :image do
        image_tag(product.image.url(:small))
      end
      row :category
    end
    active_admin_comments
  end
  permit_params :title, :image, :price, :seo_title, :seo_description, :seo_keywords, :category_id, :position
end
