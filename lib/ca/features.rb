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
                  :occurrence,
                  :standard_deviation,
                  :average

                  # occurrence - percentage use in text
                  # standard_deviation - standard deviation of distance between positions
                  # average - average distance between positions
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

    # Method that raise exeption if any of @weigths is incorrect - doesn't end with :document tag
    def correct_tags?
      @weights.each do |tags|
        last_tag = tags.last
        if last_tag != :title
          if last_tag != :document
            raise Ca::Exceptions::IncompleteTags.new("Problem with incomplete tags")
          end
        end
      end
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
      self
    end

    # Loot at @warning[+index+] and return true if any warning set
    def is_warnig_at?(index)
      return false if @words_count < 2
      @warning.at(index).any?
    end


    # Return true if words_count if greater than 1
    # False if not
    def long?
      words_count > 1
    end

    # Multiply score - if phrase is long than 1 we multiply score by it WORDS COUNT
    def multiply_score!
      @value *= @words_count
    end


    # Return @weights for position in text specified by offset
    # return Array of symbols
    def offset_weigths(offset)
      index = @positions.index(offset)
      @weights[index]
    end

    # Analyse position of phrases in context of whole text
    def position_analyse(last_index)
      distance_table = Ca::Features.intend_distances(@positions.sort, last_index)
      @value += (@position_values = position_score(distance_table))
      @occurrence = count_occurrence(last_index)
      # REMEMBER ME
      # last thing to do with value
      multiply_score!
    end

    # Rerurn standard deviation of distance table and set it in Object
    def position_score(distance_table)
      @average = distance_table.mean
      @standard_deviation = distance_table.standard_deviation
      position_score_intervals
    end

    # Return numner of points from value of standard deviation
    def position_score_intervals
      return 4 if @standard_deviation < 110
      return 2 if @standard_deviation < 250
      @standard_deviation < 375 ? 1 : 0
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
        unless is_warnig_at? index
          @values[index] = points
          @value += points
        end
      end
    end

  private
  ##########################################
  # Private methods
  ##########################################
    # count percentage occurrence of phraze in text
    def count_occurrence(last_index)
      (@frequency.to_f * @words_count.to_f / last_index.to_f * 100.00)
    end
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

    # Intend distances by table elements
    def self.intend_distances(positions, last_index)
      array, first_position = [], positions.first
      array << first_position if first_position
      nr_of_elements = positions.length - 1
      nr_of_elements.times do |index|
        array << positions[index+1] - positions[index]
      end
      array << last_index - positions.last
    end


  end
end

