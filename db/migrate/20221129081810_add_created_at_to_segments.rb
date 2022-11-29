class AddCreatedAtToSegments < ActiveRecord::Migration[7.0]
  def change
    add_column :segments, :created_at, :datetime
  end
end
