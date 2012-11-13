# encoding: utf-8
require "ca/version"
require "features"
require "ca"

module Ca
  class Description
    attr_reader :hash
    # Construct
    # Fill hash field by input from Ca::TextAnalitics.analize
    def initialize(input)
      @hash = {}
      fill_hash(input)
    end

    # Method that add +position+ and +tags+ (Array of String) to Feature of phrazes from +text+
    def add(text, tags, counter)
      p "Text my lord: "
      p text
      TextAnalitics.phrases(text, 3).each do |phrase|
        p "Phrase: <" + phrase + ">"
        # unless phrase.empty?
        #   @hash[phrase].add_weight(tags, counter)
        #   counter += 1
        # end
      end
      counter
    end

  private
    # Method to fill main hash with input values, stores hashes via Features objects
    def fill_hash(input)
      input.each do |key, value|
        @hash.store(key, Ca::Features.new(key, value, input))
      end
    end
  end

end