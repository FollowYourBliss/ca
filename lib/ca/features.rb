# encoding: utf-8
module Ca
  # Class Ca::Features
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

    def single_word_at(position)
      return self if @positions.include? position and @words_count==1
      nil
    end

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

    # Update Feature Object
    # +weight+ one weight - exp. :tr, +position+ example: 1, +length+ example: 2
    def update(weight, position, length)
      create(position)
      index = @positions.index position
      @weights[index] << weight
      @words_count = length
    end

    # Create position and weigths Array in weights for +position+ that isn't in @positions, increment frequency
    def create(position)
      unless @positions.include? position
        @frequency += 1
        @weights << []
        @positions << position
      end
    end

    # Return @weights for position in text specified by offset
    # return Array of symbols
    def offset_weigths(offset)
      index = @positions.index(offset)
      @weights[index]
    end

    # Return @words_count and @positions
    def count_with_positions
      return @words_count, @positions
    end
  end
end

