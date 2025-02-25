ActiveAdmin.register Volume do
  permit_params :value, :aqua_id, :image, :deposit, :soda, :pet

  form partial: 'admin/volumes/form'

  index do
    selectable_column
    column :id
    column :aqua
    column :value
    column :deposit
    column :image
    column :soda
    column :pet
    actions
  end

  show do |volume|
    attributes_table do
      row :aqua
      row :value
      row :soda
      row :pet
      row :deposit
      row :image do
        image_tag volume.image_url(:small)
      end
    end
    active_admin_comments
  end
end
