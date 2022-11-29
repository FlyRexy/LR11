class CreateSegments < ActiveRecord::Migration[7.0]
  def change
    create_table :segments, id: false do |t|
      t.integer :count
      t.string :sequence, primary_key: true
      t.string :largest_segment
    end
  end
end
