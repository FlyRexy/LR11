class AddAllSegmentsToSegments < ActiveRecord::Migration[7.0]
  def change
    add_column :segments, :all_segments, :json
  end
end
