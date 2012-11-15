# encoding: utf-8
require "ca/version"
require "features"
require "ca"
module Ca
  class Description
    attr_reader :hash

    # Method that add +position+ and +tags+ to Features of phrazes from +text+
    #   return counter
    def add(text, tags, counter)
      TextAnalitics.phrases(text, @phrase_lenght).each do |phrase, index|
        unless phrase.empty?
          symbol = phrase.to_sym
          if hash.key? symbol
            hash[symbol].update(tags, counter)
          else
            hash.store(symbol, Ca::Features.new(tags, counter+index, phrase.nr_of_words))

          end

        end
      end
      counter += text.nr_of_words
      counter
    end

    # Contructor, take +nokogiri_structure+ as HTML structure from Nokogiri gem to analyze, +phrase_lenght+ - max number of words in one phrase
    def initialize(nokogiri_structure, phrase_lenght = 3)
      @hash = {}
      @phrase_lenght = phrase_lenght
      Nokogiri::HTML::NodeSpecyfication.tag_analyzer(nokogiri_structure, self)
    end

    # Method display weights of phrases
    def inspect_weights
      p "Inspecting weights"
      @hash.each do |key, value|
        p "Key: #{key}, weigths_value: #{value.weights}"
      end
    end


  end
end