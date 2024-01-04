class CreateEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :enrollments do |t|
      t.boolean :completed_status, default: false
      t.belongs_to :user, foreign_key: true , index: true
      t.belongs_to :course, foreign_key: true , index: true
      t.timestamps
    end
  end
end
