class CreatePasswords < ActiveRecord::Migration[7.1]
  def change
    create_table :passwords do |t|
      t.string :url
      t.string :name, null: false
      t.string :service
      t.string :username, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end
