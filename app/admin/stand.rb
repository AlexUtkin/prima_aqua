ActiveAdmin.register Stand do

  permit_params :title, :image, :price

  form partial: 'admin/stands/form.html.haml'

  show do |stand|
    attributes_table do
      [:title, :price].each do |attr|
        row attr.to_sym
      end
      row :image do
        image_tag stand.image.url(:small)
      end
    end
    active_admin_comments
  end

end
