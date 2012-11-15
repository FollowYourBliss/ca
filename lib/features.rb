# encoding: utf-8
require "ca/version"
require "nokogiri"

module Ca
  class Features
    attr_accessor :frequency,
                  :positions,
                  :weights,
                  :words_count

    # Construct +weight+ is tag Array for example [:li, :strong, :u]
    # +position+ of phrase
    # +length+ is a phrase words number
    def initialize(weight, position, length)
      @frequency = 0
      @positions = []
      @weights = []
      @words_count = length
      update(weight, position)
    end

    # Method that update informations of phrase
    # +weight+ is a tag Array, same as initialize
    # +position+ of phrase
    def update(weight, position)
      @frequency += 1
      @positions << position
      @weights << weight
    end
  end
end

