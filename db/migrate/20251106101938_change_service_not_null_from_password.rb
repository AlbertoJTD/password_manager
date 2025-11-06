class ChangeServiceNotNullFromPassword < ActiveRecord::Migration[7.1]
  def change
    change_column_null :passwords, :service, false
  end
end
