class AddsActionsMainPagePreview < ActiveRecord::Migration
  def change
    add_column :articles, :preview_image, :string
  end
end
