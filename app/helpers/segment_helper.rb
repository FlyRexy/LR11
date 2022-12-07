module SegmentHelper
  def self.get_previous
    temp = Segment.order(:created_at).last(2).first
    p temp
    if Segment.count == 1
      temp.largest_segment = 'NULL'
    end
    temp
  end

  def self.to_db(num, original)
    i = 0
    if Segment.find_by(sequence: original.split.join(' ')).nil?
      result_arr, max_i = solve(original)
      arr_index = Array.new(result_arr.compact.length) {|_el| i+=1}
      temp_hash = Hash[arr_index.zip result_arr.compact]
      Segment.create(count: num, sequence: original.split.join(' '), largest_segment: result_arr[max_i], created_at: Time.now, all_segments: temp_hash) unless result_arr.length.zero?
      SegmentHelper.get_previous
    else
      Segment.order(:created_at).last
    end
  end

  def self.solve(arr)
    temp_count = 0
    max_count = 0
    result_arr = []
    max_i = 0
    arr = arr.split.map(&:to_i)
    i = 0
    arr.each do |el|
      temp_count, i = SegmentHelper.sqrt(el, i, result_arr, temp_count)
      if temp_count > max_count
        max_count = temp_count
        max_i = i
      end
    end
    [result_arr, max_i]
  end

  def self.sqrt(elem, ind, result_arr, temp_count)
    if Math.sqrt(elem).to_s.match(/^\d*.0$/)
      result_arr[ind] = if temp_count.zero?
                           elem.to_s
                         else
                           "#{result_arr[ind]} #{elem}"
                         end
      [temp_count + 1, ind]
    else
      [0, ind + 1]
    end
  end
end
