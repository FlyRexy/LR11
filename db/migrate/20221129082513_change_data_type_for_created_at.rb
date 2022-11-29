class ChangeDataTypeForCreatedAt < ActiveRecord::Migration[7.0]
  def change
    change_column(:segments, :created_at, :datetime)
  end
end
