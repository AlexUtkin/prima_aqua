class AddsOptionsForWaterVolume < ActiveRecord::Migration
  def change
    add_column :volumes, :soda, :boolean, default: false
    add_column :volumes, :pet,  :boolean, default: false
  end
end
