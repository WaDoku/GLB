class AddDinToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :japanische_umschrift_din, :string
  end
end
