# frozen_string_literal: true

require_relative '../day1'

RSpec.describe 'day1' do
  describe 'find_sum_to_2020' do
    it 'returns the two numbers whose sum is 2020 from the array' do
      input = [1721, 979, 366, 299, 675]
      expect(find_sum_to_2020(input)).to eq [1721, 299]
    end
  end

  describe 'find_triple_sum_to_2020' do
    it 'returns the three nubmers whose sum is 2020 from the array' do
      input = [1721, 979, 366, 299, 675]
      expect(find_triple_sum_to_2020(input)).to eq [979, 366, 675]
    end
  end
end
