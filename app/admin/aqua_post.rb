ActiveAdmin.register AquaPost do
  permit_params :aqua_id, :body, :seo_title, :seo_description, :seo_keywords, :link_url,
                :link_name, :hint, :button_name, :button_image, :title, :text_color, :image, :position

  form partial: 'admin/aqua_posts/form'

  show do |aqua_post|
    attributes_table do
      row :aqua
      row :title
      row :position
      row :text_color
      row :body
      row :button_name
      row :button_image do
        image_tag aqua_post.button_image_url(:button_image_square)
      end
      row :hint
      row :link_name
      row :link_url
      row :image do
        image_tag aqua_post.image_url(:small)
      end
      row :seo_title
      row :seo_description
      row :seo_keywords
    end
    active_admin_comments
  end


end
