# encoding: utf-8
require "ca/version"
module Ca
  class TextAnalitics

    # Return result of +text+ analysis, +max_length+ is max lenght of phrase
    #   TextAnalitics.analize("Alex have got cat") #=> {"Aleks" => 1, "have" => 1, "got" => 1, "cat" => 1}
    #   TextAnalitics.analize("Blue onion", 2) #=> {"Blue" => 1, "onion" => 1, "Blue onion" => 1}
    def self.analize(text, max_length = 1)
      result = {}
      words = text.split(separators)
      (0...max_length).each do |words_per_phrase|
        (words.size - words_per_phrase).times do |index|
          range = (index..index + words_per_phrase)
          phrase = words[range].join(" ")
          result[phrase] = 0 unless result.key?(phrase)
          result[phrase] += 1
        end
      end
      result
    end

  private
    # Return Regural Expresion for white symbols
    #   separators #=> %r{[\s,.]+}
    def self.separators
      %r{[\s,.]+}
    end


  end
end
