ActiveAdmin.register Polygon do
  permit_params :coordinates, :color, :hint

  form partial: 'admin/polygons/form'

end
