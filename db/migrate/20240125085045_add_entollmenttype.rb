class AddEntollmenttype < ActiveRecord::Migration[7.1]
  def change
    add_column :enrollments, :enrollment_type, :integer, default: 0
  end
end
