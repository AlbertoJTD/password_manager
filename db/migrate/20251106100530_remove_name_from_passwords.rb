class RemoveNameFromPasswords < ActiveRecord::Migration[7.1]
  def change
    remove_column :passwords, :name, :string
  end
end
