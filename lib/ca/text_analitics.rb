# encoding: utf-8
module Ca
  # Class Ca::TextAnalitics
  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################
    # Return phreses for +text+, +max_length+ is max lenght of phrase
    #   TextAnalitics.phrases("Anna have got cat") #=> ["Anna", "have", "got", "cat"]
    #   TextAnalitics.phrases("Blue onion", 2) #=> ["Blue", "onion", "Blue onion"]
    def self.phrases(text, max_length = 1)
      phrases_array = []

      (0...max_length).each do |words_per_phrase|
        loop_by_words(phrases_array, text, words_per_phrase)
      end
      phrases_array
    end


    # Iterates throught words table and fetch phrases from it and join with " "
    # It fill phrases_array with, for example ["ania", 1], where "ania" is a phrase and 1 is position
    def self.loop_by_words(phrases_array, text, words_per_phrase)
        words = tokenize(text)
        (words.size - words_per_phrase).times do |index|
          range = (index..index + words_per_phrase)
          phrase = words[range].join(" ")
          phrases_array << [phrase, index]
        end
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

    # Create an Array from String that is splited by TextAnalitics.separators
    def self.tokenize(text)
      text.split(separators).delete_if do |word|
        word.empty?
      end
    end
  end
end