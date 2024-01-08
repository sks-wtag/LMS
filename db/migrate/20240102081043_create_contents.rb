class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :content_type, default: "text"
      t.references :lesson, null: false, foreign_key: true
      t.timestamps
    end
  end
end
