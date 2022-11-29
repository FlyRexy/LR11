# frozen_string_literal: true

# My segments
class SegmentController < ApplicationController
  before_action :check_input, only: :result
  before_action :init, only: :result

  def input; end

  def result
    orig_array = params[:arr]
    n = params[:num].to_i
    to_db(n, orig_array)
    temp_seg = Segment.find_by_sequence(orig_array.split.join(' '))
    @result_arr = temp_seg.all_segments.values
    zero_segments
    @max_i = @result_arr.find_index(temp_seg.largest_segment)
  end

  private

  def zero_segments
    if @result_arr.compact.length.zero?
      redirect_to root_path, notice: 'Количество отрезков равно нулю'
      return
    end
  end

  def get_previous
    temp = Segment.order(:created_at).last(2).first
    if Segment.count == 1
      temp.largest_segment = 'NULL'
    end
    temp

  end

  def to_db(num, original)
    unless Segment.find_by(sequence: original.split.join(' ')).nil?
      @previous = Segment.order(:created_at).last
      return
    else
      @result_arr, @max_i = solve(original)
      arr_index = Array.new(@result_arr.length) {|_el| @i+=1}
      temp_hash = Hash[arr_index.zip @result_arr]
      Segment.create(count: num, sequence: original.split.join(' '), largest_segment: @result_arr[@max_i], created_at: Time.now, all_segments: temp_hash)
      @previous = get_previous
    end
  end

  def solve(arr)
    arr = arr.split.map(&:to_i)
    i = 0
    arr.each do |el|
      @temp_count, i = sqrt(el, i)
      if @temp_count > @max_count
        @max_count = @temp_count
        @max_i = i
      end
    end
    [@result_arr, @max_i]
  end

  def sqrt(elem, ind)
    if Math.sqrt(elem).to_s.match(/^\d*.0$/)
      @result_arr[ind] = if @temp_count.zero?
                           elem.to_s
                         else
                           "#{@result_arr[ind]} #{elem}"
                         end
      [@temp_count + 1, ind]
    else
      [0, ind + 1]
    end
  end

  def init
    @result_arr = []
    @max_i = 0
    @temp_count = 0
    @max_count = 0
    @i = 0
  end

  def check_input
    a = params[:arr]
    n = params[:num].to_i
    if a.nil? || n.nil?
      a = '1 4 9 2 1'
      n = 5
    end
    redirect_to root_path, alert: 'Заданное количество элементов не совпадает с реальным' if n != a.split.length
    return if a.match(/^\s*(\d+\s*)*$/)

    redirect_to root_path, alert: 'Неправильный ввод'
  end
end
