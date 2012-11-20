# encoding: utf-8

module Ca
  class Description

  ##########################################
  # Getters
  ##########################################
    attr_reader :hash,
                :text,
                :notyfications


  ##########################################
  # Object methods
  ##########################################

    # Method that add +position+ and +tags+ to Features of phrazes from +text+
    #   return counter
    def add(text, tags, counter)
      text.downcase!
      TextAnalitics.phrases(text, @phrase_lenght).each do |phrase, index|
        unless phrase.empty?
          symbol = phrase.to_sym
          if hash.key? symbol
            hash[symbol].update(tags, counter+index)
          else
            hash.store(symbol, Ca::Features.new(tags, counter+index, phrase.nr_of_words))
          end
        end
      end
    end

    # Contructor, take +nokogiri_structure+ as HTML structure from Nokogiri gem to analyze, +phrase_lenght+ - max number of words in one phrase
    # Additionaly save +nokogiri_structure+ to Object variable @text
    def initialize(nokogiri_structure, phrase_lenght = 3)
      @hash, @text, @notyfications = {}, nokogiri_structure, []
      @phrase_lenght = phrase_lenght
      Nokogiri::HTML::NodeSpecyfication.tag_analyzer(nokogiri_structure, self)
      mark_warnings
      attributes_analyzer
    end

  ##########################################
  # Private methods
  ##########################################
  private
    # Method that mark long phrases with forbidden tags as warned
    # We take phrase and find all his parts, to check if they aren't forbidden
    # If +fail_counter+ is between number of words in phrase minus 1 and 1
    # Than we know that any but not every single pharse if forbidden
    # Becouse if every single pharse is in forbiddent it is no problem
    def mark_warnings

      long_phrases.each_pair do |long_phrase, features|
        features.positions.each do |position|
          fail_counter = 0
          warning = Warning.new
          (0...features.words_count).each do |index|
            offset = position + index
            fetch_phrases_at(offset).each_pair do |short_phrase, short_features|
              array_index = short_features.positions.index(offset)
              fail_counter += 1 if Nokogiri::HTML::NodeSpecyfication.forbidden?(short_features.weights[array_index])
            end
          end
          warning.forbidden_tags_warning if fail_counter.between?(1,features.words_count)
          features.warning << warning
        end
      end


    end

    # Method that fetch long_phrases from all phrases in @hash
    def long_phrases
      hash = {}
      @hash.each_pair do |key,value|
        hash.store(key, value) if value.words_count>1
      end
      hash
    end


    # Method fetch all phrases at +number+ place
    #   for analyze_text "Koko Foo" with number 0 #=> {:"Koko Foo" => Features, :Koko => Features}
    #   for analyze_text "Koko Foo Mi" with number 1 #=> {:Foo => Feature, :"Foo Mi" => Features}
    def fetch_phrases_at(number)
      @hash.select do |key, value|
        value.positions.include? number and value.words_count==1
      end
    end

    # Method analyze attributes and contents of each tags
    def attributes_analyzer
      Ca::TextAnalitics.all_nodes(text).each do |tags|
        tags.each do |node|
          begin
            Ca::TextAnalitics.node_attributes_analyze(node)
          rescue Ca::Exceptions::TagWarnings => error
            node.add_class(error.klass)
          end
        end
      end

    end

  end
end