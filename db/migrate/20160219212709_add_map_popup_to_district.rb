class AddMapPopupToDistrict < ActiveRecord::Migration
  def change
    add_column :districts, :map_popup, :string
  end
end
