class CreatePolygons < ActiveRecord::Migration
  def change
    create_table :polygons do |t|
      t.text :coordinates
      t.string :color
      t.string :hint

      t.timestamps
    end
  end
end
