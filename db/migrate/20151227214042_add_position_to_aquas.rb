class AddPositionToAquas < ActiveRecord::Migration
  def change
    add_column :aquas, :position, :integer
  end
end
