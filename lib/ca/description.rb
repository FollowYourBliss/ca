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
    def add(text, tags, counter)
      phrases = TextAnalitics.phrases(text.downcase, @phrase_lenght)
      phrases.each do |phrase, index|
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
      key, words_count = phrase.to_sym, phrase.nr_of_words
      @hash[key] = Ca::Features.new unless @hash.has_key? key
      @hash[key].update(tags, position, words_count)
    end

    # Method fetch all phrases at +number+ place
    #   for analyze_text "Koko Foo" with number 0 #=> {:"Koko Foo" => Features, :Koko => Features}
    #   for analyze_text "Koko Foo Mi" with number 1 #=> {:Foo => Feature, :"Foo Mi" => Features}
    def fetch_phrases_at(position)
      @hash.select do |key, value|
        value.single_word_at(position)
      end
    end

    # Fetch long phrases from all phrases in @hash
    # Long phrases have got words_count > 0
    def long_phrases
      hash = @hash
      hash.keep_if do |key, feature|
        feature.words_count > 0
      end
    end

    # Method that mark long phrases with forbidden tags as warned
    # We take phrase and find all his parts, to check if they aren't forbidden
    # Than we know that any but not every single pharse if forbidden
    # Becouse if every single pharse is in forbiddent it is no problem
    def mark_warnings
      long_phrases.values.each do |features|
        long_phrase_warning(features)
      end
    end

    # Check if one word single phrase at +offset+ have got forbiddent tag in it Feature Object
    # if do, we increment +counter+ - failcounter
    def phraze_fail?(offset, counter)
      fetch_phrases_at(offset).values.each do |features|
        counter += 1 if Nokogiri::HTML::NodeSpecyfication.forbidden?(features.offset_weigths(offset))
      end
      counter
    end

    # Add warning class to every phrase, fill it if we have got any warning
    # Check every position in position hash
    def long_phrase_warning(features)
      words_count, positions = features.count_with_positions
      positions.each do |position|
        fails, warning = position_fail?(words_count, position, 0), Warning.new
        warning.forbid if fails.between?(1, words_count-1)
        features.warning << warning
      end
    end

    # Check every word in phraze by his position
    # +words_count+ - number of words in checking phrase
    # +position+ - position of checking phrase
    # +counter+ - fail counter, counter that increment when we are at forbidden tag
    #  return +counter+
    def position_fail?(words_count, position, counter)
      words_count.times do |index|
        offset = position + index
        counter = phraze_fail?(offset, counter)
      end
      counter
    end
  end
end