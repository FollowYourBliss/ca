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
                  :warning,
                  :node_id,
                  :values,
                  :value,
                  :position_values,
                  :occurrence

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

    # Create position and weigths Array in weights for +position+ that isn't in @positions, increment frequency
    def create(position)
      unless @positions.include? position
        @frequency += 1
        @weights << []
        @node_id << []
        @positions << position
      end
    end

    # Make hash of tags and their node_id and fatch from it only with forbidden tags
    # Ca::Analyse.new("ala ma kota <ol><li>ko</li><li>ko</li><li>ko</li></ol>").description.hash[:ko].fetch_forbidden_nodes(4) #=> {li: 6, ol: 9}
    def fetch_forbidden_nodes(position)
      weights_and_ids(position).keep_if do |key, value|
        Nokogiri::HTML::NodeSpecyfication.forbidden_tags.include? key
      end
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
      @frequency, @value, @position_values, @occurrence = 0, 0, 0, 0.00
      @positions, @weights, @warning, @node_id, @values = [], [], [], [], []
    end

    # Return true if words_count if greater than 1
    # False if not
    def long?
      words_count > 1
    end

    # Return @weights for position in text specified by offset
    # return Array of symbols
    def offset_weigths(offset)
      index = @positions.index(offset)
      @weights[index]
    end

    # Return self if @position include +position+
    def single_word_at(position)
      return self if @positions.include? position and @words_count==1
      nil
    end

    # Update Feature Object
    # +weight+ one weight - exp. :tr, +position+ example: 1, +length+ example: 2
    def update(weight, position, length)
      create(position)
      index = @positions.index position
      @weights[index] << weight
      @node_id[index] << Ca::NodeCounter.instance.value
      @words_count = length
    end

    # Fill all values in @values
    def tag_value_analyser
      @positions.each_index do |index|
        points = Ca::Features.count_points(@weights[index])
        @values[index] = points
        @value += points
      end
    end

  private
  ##########################################
  # Private methods
  ##########################################
    # Make hash where key is weigth value (like :li or :body) and value is node_id of his node
    # argument +position+ specify position of examinated Feature Object
    def weights_and_ids(position)
      index = @positions.index position
      Hash[@weights[index].zip(@node_id[index])]
    end

    # Count number of points for weights from Object
    #   Ca::Features.count_points([:tr, :b, :li]) #=> Fixnum
    def self.count_points(weights_array)
      points = 0
      tags_strength = Ca::Config.instance.tags_strength
      common = tags_strength.keys & weights_array
      common.each do |key|
        points += tags_strength[key]
      end
      points
    end
  end
end

