class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :name
      t.text :description
      t.string :type, default: "text"
      t.references :lesson, null: false, foreign_key: true
      t.timestamps
    end
  end
end
