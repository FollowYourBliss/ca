# encoding: utf-8
module Ca
  # Class Ca::Description
  # Stores information of Text Analitics and Text that we Analyse
  class Description

  ##########################################
  # Getters
  ##########################################
  # hash - hash where key is phrase and valude is his Feature Object
  # text - text we've analysed
    attr_reader :hash,
                :text


  ##########################################
  # Object methods
  ##########################################

    # Method that add +position+ and +tags+ to Features of phrazes from +text+
    #   fill @hash
    #   return counter
    def add(text, tags, counter)
      text.downcase!
      TextAnalitics.phrases(text, @phrase_lenght).each do |phrase, index|
        position = counter+index
        unless phrase.empty?
          symbol = phrase.to_sym
          create_or_update(tags, position, phrase)
        end
      end
    end



    # Contructor, take +nokogiri_structure+ as HTML structure from Nokogiri gem to analyze, +phrase_lenght+ - max number of words in one phrase
    # Additionaly save +nokogiri_structure+ to Object variable @text
    def initialize(nokogiri_structure, phrase_lenght = 3)
      @hash, @text = {}, nokogiri_structure
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
      long_phrases.values.each do |features|
        method3(features)
      end
    end

    def method1(offset, counter)
      fetch_phrases_at(offset).values.each do |features|
        index = features.positions.index(offset)
        counter += 1 if Nokogiri::HTML::NodeSpecyfication.forbidden?(features.weights[index])
      end
      counter
    end


    def method2(words_count, position, counter)
      words_count.times do |index|
        offset = position + index
        method1(offset, counter)
      end
    end

    def method3(features)
      words_count, positions = features.words_count, features.positions
      range = 1...words_count
      positions.each do |position|
        warning, fails = Warning.new, 0
        method2(words_count, position, fails)
        warning.forbid if range.include? fails
        features.warning << warning
      end
    end

    # Fetch long_phrases from all phrases in @hash
    def long_phrases
      @hash.keep_if do |key, feature|
        feature.words_count > 1
      end
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
      Ca::TextAnalitics.all_nodes(text).each do |node|
          begin
            Ca::TextAnalitics.node_attributes_analyze(node)
          rescue Ca::Exceptions::TagWarnings => error
            node.add_class(error.klass)
          end
      end

    end

    # Create if don't exist key in hash or update hash if not empty
    #   Description<Hash:nil>.create_or_update_hash("a", 1, 1, :sample) #=>  Description<Hash:sample:Feature>
    #   Description<Hash:sample:Feature>.create_or_update_hash("a", 1, 1, :sample) #=>  Description<Hash:sample:Feature>
    def create_or_update(tags, position, phrase)
      # p "Create or update #{tags} #{position} #{phrase}"
      symbol, words_count = phrase.to_sym, phrase.nr_of_words
      @hash[symbol] = Ca::Features.new unless @hash.has_key? symbol
      @hash[symbol].update(tags, position, words_count)
    end
  end
end