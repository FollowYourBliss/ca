# encoding: utf-8
module Ca
  # Class Ca::Feature
  class Features
  ##########################################
  # Getters and setters
  ##########################################
    attr_accessor :frequency,
                  :positions,
                  :weights,
                  :words_count,
                  :warning

  ##########################################
  # Object methods
  ##########################################

    # Return true if any warning in warning Object field is set to true
    #   @warning = [[true, true, true], [true, false]] #=> true
    #   @warning = [[false, false], [false, false]] #=> false
    def any_warnings?
      @warning.map { |warning|
        warning.any?
      }.any?
    end

    # Method mark Object as warning, we use it to select
    # phrases as "List <li>eggs" like warned, becouse <li> is forbidden
    def forbidden_warning
      @warning.forbid
    end

    # Construct +weight+ is tag Array for example [:li, :strong, :u]
    # +position+ of phrase
    # +length+ is a phrase words number
    def initialize
      @frequency = 0
      @positions, @weights, @warning = [], [], []
    end

    # Method that update informations of phrase
    # +weight+ is a tag Array, same as initialize
    # +position+ of phrase
    def update(weight, position, length)
      @words_count = length
      if @positions.include? position
        index = @positions.index position
        @weights.at(index) << weight unless @weights.at(index).include?(weight)
      else
        @frequency += 1
        @positions << position
        @weights << [weight]
      end
    end
  end
end

