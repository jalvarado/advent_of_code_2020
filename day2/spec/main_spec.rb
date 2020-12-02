# frozen_string_literal: true

require_relative '../main'

RSpec.describe 'day2' do
  describe 'valid_password_count_by_index' do
    it 'returns the number of valid passwords' do
      input_lines = [
        '1-3 a: abcde',
        '1-3 b: cdefg',
        '2-9 c: ccccccccc'
      ]
      expect(valid_password_count_by_index(input_lines)).to eq 1
    end
  end

  describe 'valid_password_by_index' do
    context 'when password is valid' do
      it 'returns true' do
        line = '1-3 a: abcde'
        expect(valid_password_by_index?(line)).to be true
      end
    end

    context 'when the password is invalid' do
      it 'returns false' do
        line = '2-9 c: ccccccccc'
        expect(valid_password_by_index?(line)).to be false
      end
    end
  end

  describe 'valid_password_count' do
    it 'returns the number of valid passwords' do
      input_lines = [
        '1-3 a: abcde',
        '1-3 b: cdefg',
        '2-9 c: ccccccccc'
      ]
      expect(valid_password_count(input_lines)).to eq 2
    end
  end

  describe 'valid_password?' do
    context 'when password is valid' do
      it 'returns true' do
        line = '1-3 a: abcde'
        expect(valid_password?(line)).to be true
      end
    end

    context 'when the password is invalid' do
      it 'returns false' do
        line = '1-3 a: cdefg'
        expect(valid_password?(line)).to be false
      end
    end
  end
end
