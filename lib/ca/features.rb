# encoding: utf-8
require "nokogiri"

module Ca
  class Features
    attr_accessor :frequency,
                  :positions,
                  :weights,
                  :words_count,
                  :warning

    # Construct +weight+ is tag Array for example [:li, :strong, :u]
    # +position+ of phrase
    # +length+ is a phrase words number
    def initialize(weight, position, length)
      @frequency = 0
      @positions = []
      @weights = []
      @words_count = length
      @warning = []
      update(weight, position)
    end

    # Method that update informations of phrase
    # +weight+ is a tag Array, same as initialize
    # +position+ of phrase
    def update(weight, position)
      if @positions.include? position
        index = @positions.index position
        @weights.at(index) << weight unless @weights.at(index).include?(weight)
      else
        @frequency += 1
        @positions << position
        @weights << [weight]
      end
    end


    # Method mark Object as warning, we use it to select
    # phrases as "List <li>eggs" like warned, becouse <li> is forbidden
    def forbidden_warning
      @warning.forbidden_tags_warning
    end

    def any_warnings?
      @warning.map { |warning|
        warning.any?
      }.any?
    end
  end
end

