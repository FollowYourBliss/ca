# encoding: utf-8
require "ca/version"
module Ca
  class TextAnalitics

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
      return phrases
    end

  private
    # Return Regural Expresion for white symbols
    #   separators #=> %r{[\s,.]+}
    def self.separators
      %r{[\s,.]+}
    end

    def self.tokenize(text)
      text.split.delete_if do |e|
        e.empty?
      end
    end

  end
end


