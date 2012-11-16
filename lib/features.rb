# encoding: utf-8
require "ca/version"
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

    # Check if some of weigths are forbidden
    #   long_phrase = nadrzędne
    #   @weigths = porzędne
    def forbidden?(long_phrase)
      phrase_length = long_phrase.words_count
      positions = long_phrase.positions
      positions.each do |position|

      end
      self.class
      # Nokogiri::HTML::NodeSpecyfication.forbidden?(weigths)
    end

    # Method mark Object as warning, we use it to select
    # phrases as "List <li>eggs" like warned, becouse <li> is forbidden
    def warn(bool)
      @warning << bool
    end
  end
end

