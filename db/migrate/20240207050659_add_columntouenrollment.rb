class AddColumntouenrollment < ActiveRecord::Migration[7.1]
  def change
    add_column :enrollments, :completion_time, :datetime
  end
end
