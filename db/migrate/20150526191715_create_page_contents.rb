class CreatePageContents < ActiveRecord::Migration
  def change
    create_table :page_contents do |t|
      t.integer :relation
      t.string :main_header
      t.text :main_text
      t.string :main_image
      t.string :additional_header
      t.text :additional_text
      t.string :seo_title
      t.string :seo_description
      t.string :seo_keywords

      t.timestamps
    end
  end
end
