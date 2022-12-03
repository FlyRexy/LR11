# frozen_string_literal: true

# My segments
class SegmentController < ApplicationController
  before_action :init, only: :result
  before_action :check_input, only: :result
  before_action :check_count, only: :result

  def input; end

  def result
    @previous = SegmentHelper.to_db(@n, @orig_array)
    temp_seg = Segment.find_by_sequence(@orig_array.split.join(' '))
    segments = temp_seg&.all_segments&.values
    @result_arr = segments.nil? ? [] : segments
    zero_segments
    @max_i = @result_arr.find_index(temp_seg&.largest_segment)
  end

  def view
    @rows = Segment.all
    @rows = @rows.each do |el|
      i = 0
      numbers = Array.new(el.all_segments.values.length) do |_el|
        { value: el.all_segments.values[i], index: i += 1 }
      end
      el.all_segments = numbers
    end
    render xml: @rows
  end

  private

  def zero_segments
    return unless @result_arr.compact.length.zero?

    redirect_to root_path, notice: 'Количество отрезков равно нулю'
    nil
  end

  def init
    @result_arr = []
    @max_i = 0
    @orig_array = params[:arr].nil? ? '1 2 3 4 5' : params[:arr]
    @n = !params[:num].nil? ? params[:num].to_i : 5
  end

  def check_input
    return if @orig_array.match(/^\s*(\d+\s*)*$/)

    redirect_to root_path, alert: 'Неправильный ввод'
  end

  def check_count
    return unless @n != @orig_array.split.length

    redirect_to root_path,
                alert: 'Заданное количество элементов не совпадает с реальным'
  end
end
