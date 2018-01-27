class AddRemindedToAssignment < ActiveRecord::Migration
  def change
    add_column :assignments, :reminded, :boolean, default: false
  end
end
