# frozen_string_literal: true
class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :content_type, default: 'text'
      t.references :lesson, null: false, foreign_key: true
      t.timestamps
    end
  end
end
