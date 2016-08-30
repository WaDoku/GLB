class AddSeiteTextblock2005ToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :seite_textblock2005, :string
  end
end
