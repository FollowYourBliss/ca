# encoding: utf-8
module Ca
  # Class Ca::TextAnalitics
  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################
    # Return result of +text+ analysis, +max_length+ is max lenght of phrase
    #   TextAnalitics.analize("Anna have got cat") #=> {"Anna" => 1, "have" => 1, "got" => 1, "cat" => 1}, ["Anna", "have", "got", "cat"]
    #   TextAnalitics.analize("Blue onion", 2) #=> {"Blue" => 1, "onion" => 1, "Blue onion" => 1}, ["Blue", "onion"]
    def self.analize(text, max_length = 1)
      result = {}
      words = tokenize(text)
      (0...max_length).each do |words_per_phrase|
        (words.size - words_per_phrase).times do |index|
          range = (index..index + words_per_phrase)
          phrase = words[range].join(" ")
          result[phrase] = 0 unless result.key?(phrase)
          result[phrase] += 1
        end
      end
      return result, words
    end

    # Return phreses for +text+, +max_length+ is max lenght of phrase
    #   TextAnalitics.phrases("Anna have got cat") #=> ["Anna", "have", "got", "cat"]
    #   TextAnalitics.phrases("Blue onion", 2) #=> ["Blue", "onion", "Blue onion"]
    def self.phrases(text, max_length = 1)
      phrases = []
      words = tokenize(text)
      (0...max_length).each do |words_per_phrase|
        (words.size - words_per_phrase).times do |index|
          range = (index..index + words_per_phrase)
          phrase = words[range].join(" ")
          phrases << [phrase, index]
        end
      end
      phrases
    end

    # Return all nodes from Nokogiri::HTML structure
    def self.all_nodes(nokogiri_structure)
      nokogiri_structure.css("a") + nokogiri_structure.css("img")
    end

    # Analyse one node - like to throw Exceptions
    def self.node_attributes_analyze(node)
      case node.name
      when "a" then a_analyze(node)
      when "img" then img_analyze(node)
      when "title" then title_analyze(node)
      else "Nothing match"
      end
    end

  ##########################################
  # Private methods
  ##########################################
  private
    # Return Regural Expresion for white symbols
    #   separators #=> %r{[\s,.]+}
    def self.separators
      %r{[\s,.]+}
    end

    def self.tokenize(text)
      text.split(separators).delete_if do |word|
        word.empty?
      end
    end


  end

end