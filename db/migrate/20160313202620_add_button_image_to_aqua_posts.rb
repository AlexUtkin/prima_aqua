class AddButtonImageToAquaPosts < ActiveRecord::Migration
  def change
    add_column :aqua_posts, :button_image, :string
  end
end
