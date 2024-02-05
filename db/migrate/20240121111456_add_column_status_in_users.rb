class AddColumnStatusInUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :integer, default: 1
  end
end
