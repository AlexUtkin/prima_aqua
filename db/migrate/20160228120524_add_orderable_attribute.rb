class AddOrderableAttribute < ActiveRecord::Migration
  def change
    add_column :coolers, :orderable, :boolean
    add_column :accessories, :orderable, :boolean
    add_column :products, :orderable, :boolean
    add_column :pomps, :orderable, :boolean
  end
end
