class CreateStands < ActiveRecord::Migration
  def change
    create_table :stands do |t|
      t.string :title
      t.string :image
      t.integer :price

      t.timestamps
    end
  end
end
