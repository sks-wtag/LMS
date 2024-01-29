class AddPictureUrl < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :pic_url, :string, null: false
  end
end
