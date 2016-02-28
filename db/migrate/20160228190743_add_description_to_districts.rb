class AddDescriptionToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :description, :text
  end
end
