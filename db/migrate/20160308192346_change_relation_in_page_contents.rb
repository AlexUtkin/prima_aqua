class ChangeRelationInPageContents < ActiveRecord::Migration
  def change
    change_column :page_contents, :relation, :string
  end
end
