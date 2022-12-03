# frozen_string_literal: true

require_relative 'spec_helper'
require_relative 'rails_helper'

# testing PalindromsController
RSpec.describe SegmentHelper do
  context 'when we test functions' do
    it 'returns correct result' do
      expect(SegmentHelper.solve('1 4 9 5 1')).to eq([['1 4 9', '1'], 0])
      expect(SegmentHelper.solve('2 2 2')).to eq([[], 0])
    end
  end
end

RSpec.describe SegmentController, type: :controller do
  describe 'page input' do
    it 'has a 200 status code' do
      get :input
      expect(response.status).to eq(200)
    end
  end

  describe 'page result' do
    it 'has a 200 status code' do
      get :result
      expect(response.status).to eq(200)
    end
  end

  describe 'page viewBD' do
      it 'has a 200 status code' do
        get :view
        expect(response.status).to eq(200)
      end
  end
end

RSpec.describe SegmentController, type: :request do
  context 'notice message test' do
    it 'return notice message' do
      get '/segment/result?num=4&arr=1 2 3 4 5'
      expect(flash[:alert]).to eq('Заданное количество элементов не совпадает с реальным')
    end
  end

  context 'adding to database' do
    it 'added to db' do
      expect(Segment.where(sequence: '1 81 3 4').count).to eq(0)
      row = {count: 4, sequence: '1 81 3 4', largest_segment: '1 81', created_at: Time.now, all_segments: {'1': '1 81', '2': '4'}}
      Segment.create(row)
      expect(Segment.where(sequence: '1 81 3 4').count).to eq(1)
      Segment.find_by_sequence('1 81 3 4').delete
    end
  end

  context 'when we add data and search for it' do
    it 'should return correct answer' do
      SegmentHelper.to_db(4, '100 16 5 1')
      expect(Segment.find_by_sequence('100 16 5 1').largest_segment).to eq('100 16')
    end
  end
end

RSpec.describe SegmentController, type: :request do
  context 'when we add same data to db' do
    it "doesn't add repeated data" do
      SegmentHelper.to_db(5, '1 2 3 4 5')
      expect(Segment.where(sequence: '1 2 3 4 5').count).to eq(1)
    end
  end
end
