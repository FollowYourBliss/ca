# encoding: utf-8
require "ca/version"
require "nokogiri"

module Ca
  class Features
    attr_accessor :frequency,
                  :positions,
                  :weights,
                  :words_count

    #
    def initialize(key, value, text_as_array)
      @frequency = value
      @words_count = (@words_table = key.split(" ")).count
      @positions, @weights = [], []
      fill_positions(text_as_array)
    end

    def add_weight(weight, position)
      @positions << position
      @weights << weight
    end

  private

    def fill_positions(text_as_array)
      (text_as_array.length - @words_count).times do |index|
        @positions << index if text_as_array[index...index+@words_count] == @words_table
      end
    end

  end
end

