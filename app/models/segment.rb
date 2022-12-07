class Segment < ApplicationRecord
  include ActiveModel::Serializers::Xml
  include SegmentHelper
  validates :sequence, :count, presence: { message: "can't be empty" }
  validate :check_input
  validates :sequence, format: { with: /^\s*(\d+\s*)*$/, multiline: true, message: 'must contain only positive numbers' }
  def result
    @previous = SegmentHelper.to_db(count, sequence)
    @finder = Segment.find_by_sequence(sequence.split.join(' '))
    @result_arr = @finder&.all_segments&.values
    @max_i = @result_arr&.find_index(@finder&.largest_segment)
    [@result_arr, @max_i, @previous]
  end

  def check_input
    if count != sequence.split.length
      errors.add(:number, "of elements in array are not matching with first field")
    end
  end
end
