class CreateUserCourseProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :user_course_progresses do |t|
      t.boolean :complete_status, default: false
      t.datetime :complete_time
      t.references :user, null: false, foreign_key: true
      t.references :enrollment, null: false, foreign_key: true
      t.references :lesson, null: false, foreign_key: true
      t.timestamps
    end
  end
end
