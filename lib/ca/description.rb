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
    def initialize(nokogiri_structure, phrase_lenght = Ca::Configuration.instance.phrase_length)
      @hash, @text = {}, nokogiri_structure
      @phrase_lenght = phrase_lenght
      Nokogiri::HTML::NodeSpecyfication.tag_analyzer(nokogiri_structure, self)
      mark_warnings
      attributes_analyzer
      Ca::NodeCounter.instance.reset
      sort_by(:frequency)
    end

  ##########################################
  # Private methods
  ##########################################
  private
    ##########################################
    # Class Private methods
    ##########################################
    # Anazyse array - if it have got all elements the same return false, becouse that isn't phrase with forbidden tags
    # return true if any of element isn't same as others
    #   Ca::Description.result_anayse([{li: 5}, {li: 5}]) #=> false
    #   Ca::Description.result_anayse([{li: 5, ol: 1}, {li: 5, ol: 5}]) #=> true
    def self.result_analyse(array)
      array.count(array.first)!=array.size
    end

    ##########################################
    # Object Private methods
    ##########################################
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

    # Add warning class to every phrase, fill it if we have got any warning
    # Check every position in position hash
    def long_phrase_warning(feature)
      feature.positions.each do |phrase_position|
        warning = Warning.new
        warning.forbid if phrase_at_position_forbidden?(feature, phrase_position)
        feature.warning << warning
      end
    end

    # Method that mark long phrases with forbidden tags as warned
    # We take phrase and find all his parts, to check if they aren't forbidden
    # Than we know that any but not every single pharse if forbidden
    # Becouse if every single pharse is in forbiddent it is no problem
    def mark_warnings
      @hash.values.each do |feature|
        if feature.long?
          long_phrase_warning(feature)
        end
      end
    end

    # Check if phrease at position is forbidden
    def phrase_at_position_forbidden?(feature, phrase_position)
      words_array = phrase_words_array(phrase_position, feature)
      Ca::Description.result_analyse(words_array)
    end

    # Make array of forbidden tags in phrase by checking every word and fetch hash of forbidden tags keys
    #   example retrun: [{li: 3, ol: 5}, {}, {ol: 6}]
    def phrase_words_array(phrase_position, phrase_info)
      array = []
      phrase_info.words_count.times do |index|
        position = phrase_position + index
        array << fetch_phrases_at(position).values.first.fetch_forbidden_nodes(position)
      end
      array
    end

    # Sort hash by any number value from Feature Object
    def sort_by(field)
      @hash = Hash[
        @hash.sort_by { |key, value|
          -value.send(field)
        }
      ]
    end
  end
end