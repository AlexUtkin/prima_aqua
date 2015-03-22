ActiveAdmin.register AquaPost do
  permit_params :aqua_id, :body, :seo_title, :seo_description, :seo_keywords, :link_url,
                :link_name, :button_url, :button_name, :title, :text_color, :image

  form partial: 'admin/aqua_posts/form'

  show do |aqua_post|
    attributes_table do
      row :aqua
      row :text_color
      row :title
      row :body
      row :button_name
      row :button_url
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
