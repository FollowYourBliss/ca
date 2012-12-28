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
                :text,
                :plagiarism,
                :problems,
                :tag_problem_flag,
                :nr_of_nodes

  ##########################################
  # Object methods
  ##########################################

    # Method that add +position+ and +tags+ to Features of phrazes from +text+
    #   fill @hash
    def add(text, tags, counter)
      phrases = TextAnalitics.phrases(text.down_case, @phrase_lenght)
      phrases.each do |phrase, index|
        position = counter+index
        unless phrase.empty?
          symbol = phrase.to_sym
          create_or_update(tags, position, phrase)
        end
      end
    end

    # Return all problems
    def display_problems
      @problems.map do |problem|
        problem.to_s
      end
    end

    # Fetch first n elements from @hash attribute
    def first_n(number = Ca::Config.instance.phrase_to_csv)
      @hash.first(number)
    end


    # Contructor, take +nokogiri_structure+ as HTML structure from Nokogiri gem to analyze, +phrase_lenght+ - max number of words in one phrase
    # Additionaly save +nokogiri_structure+ to Object variable @text
    def initialize(nokogiri_structure, phrase_lenght = Ca::Config.instance.phrase_length)
      variables_set(nokogiri_structure, phrase_lenght)
      Nokogiri::HTML::NodeSpecyfication.tag_analyzer(nokogiri_structure, self)
      mark_warnings
      attributes_analyzer
      @nr_of_nodes = Ca::NodeCounter.instance.value
      Ca::NodeCounter.instance.reset
      run_tag_analyse!
      run_position_analyse!(text_number_of_words)
      clean!
      check_harmony
      sort_by(:value)
      plagiarism_test
      fetch_problems

      self
    end

    # Return all problems as symbols
    def problems_as_sym
      @problems.map do |problem|
        problem.to_sym
      end
    end

    # Return page score countet via top n phrases
    def score
      score = 0
      first_n.each do |key, value|
        score += value.value
      end
      if @plagiarism
        score -= -100
      end
      score
    end

    # Create Hash of most valuable information about description
    # useful to parse it to web application
    def result
      {
        problems: problems,
        text: text,
        best_phrases: Hash[first_n],
        nr_of_chars: text_number_of_chars,
        nr_of_words: text_number_of_words,
        nr_of_nodes: nr_of_nodes,
        score: score,
        plagiarism: plagiarism,
        html: text.to_s.force_encoding("UTF-8"),
        tags_problem: tag_problem_flag
      }
    end

    # Return number of chars for text in object without " " and "\n"
    def text_number_of_chars
      @text.text.number_of_chars
    end

    # Return number of words for text
    # (remember to run this after analyze)
    def text_number_of_words
      @text.text.nr_of_words
    end

    # Create files in folder tmp first have positions table to draw chart
    # second is every phrase standard deviation
    def to_csv(filename)
      simple_position_csv(filename)
      standard_deviation_csv(filename)
      tags_lookout_csv(filename)
      extra_debug_files(filename)
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
            @tag_problem_flag = true
          end
      end
    end

    # Clean Description hash from short phrases or phrases with warnings
    # and excluded words
    def clean!
      @hash.delete_if do |key, value|
        key.to_s.size == 1 or
        Ca::Config.instance.excluded.include? key
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

    # Run methods to generate addiotion defbug files such as:
       # yaml file of @hash,
       # html file of @text,
       # txt file of @hash
    def extra_debug_files(filename)
      yaml_file(filename)
      html_file(filename)
      txt_file(filename)
    end

    # Method fetch all phrases at +number+ place
    #   for analyze_text "Koko Foo" with number 0 #=> {:"Koko Foo" => Features, :Koko => Features}
    #   for analyze_text "Koko Foo Mi" with number 1 #=> {:Foo => Feature, :"Foo Mi" => Features}
    def fetch_phrases_at(position)
      @hash.select do |key, value|
        value.single_word_at(position)
      end
    end

    # Fill table of problems that should be fix by user
    def fetch_problems
      @problems << Ca::H1Problem.new unless @text.one_h1?
      @problems << Ca::MetaDescriptionProblem.new if @text.empty_meta_description?
      @problems << Ca::MetaKeywordsProblem.new if @text.empty_meta_keywords?
      @problems << Ca::TitleProblem.new if @text.empty_title?
    end

    # Parse @text to HTML and save it into the tml/filename.html
    def html_file(filename)
      filename = "tmp/#{filename}.html"
      File.open(filename, "wb") do |file|
        file.write(@text.to_html)
      end
      puts "  #{filename}  - created"
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

    # For first_n methood save in csv file located at /tml/+filename+.csv all its positions
    def simple_position_csv(filename)
      filename = "tmp/#{filename}.csv"
      CSV.open(filename, "wb") do |csv|
        csv << ["phrase", "positions"]
        first_n.each do |hash|
          csv << [hash.first.to_s] +  hash.last.positions
        end
      end
      puts "  #{filename}  - created"
    end


    # Sort hash by any value (number value) from Feature Object
    def sort_by(field)
      @hash = Hash[
        @hash.sort_by { |key, value|
          -value.send(field)
        }
      ]
    end

    # Create CSV file with stadard deviation of position array for each key in @hash, save it in tmp/+filename+.csv
    def standard_deviation_csv(filename)
      filename = "tmp/#{filename}_standard_deviation.csv"
      CSV.open(filename, "wb") do |csv|
        csv << ["phrase", "standard_deviation", "score"]
        @hash.each do |key, value|
          csv << [key.to_s, value.standard_deviation, value.value]
        end
      end
      puts "  #{filename}  - created"
    end

    # Tag analyze for each feature in out @hash
    def run_tag_analyse!
      @hash.values.each do |feature|
        feature.tag_value_analyser
      end
    end

    # Position analyse for each phrase
    def run_position_analyse!(all_words)
      @hash.each do |key, feature|
        feature.position_analyse(all_words)
      end
    end

    # For each key in @hash argument and it's name and weights save them to file tml/+filename+_tags_lookout.csv
    def tags_lookout_csv(filename)
      filename = "tmp/#{filename}_tags_lookout.csv"
      CSV.open(filename, "wb") do |csv|
        @hash.each do |key, value|
          csv << [key.to_s]
          csv << [value.weights]
        end
      end
      puts "  #{filename}  - created"
    end

    # Check every hash value by run correct_tags? on it, throw exeption
    def check_harmony
      @hash.each do |key, value|
            value.correct_tags?
      end
    end


    # Check exitising of simmillar text in internet
    def plagiarism_test
      test = Ca::SimilarTest.new(@text.text)
      test.run
      @plagiarism = test.result
    end

    # Save @hash atribute in tmp/+filename+.txt
    def txt_file(filename)
      filename = "tmp/#{filename}.txt"
      File.open(filename, "w+") do |file|
        file.write(@hash)
      end
      puts "  #{filename}  - created"
    end

    # Initialize Object attributes
    def variables_set(nokogiri_document, phrase_lenght)
      @hash, @text = {}, nokogiri_document
      @phrase_lenght, @problems = phrase_lenght, []
      @tag_problem_flag = false
    end


    # Parse @hash attribute and save it in tmp/+filename+.yml
    def yaml_file(filename)
      filename = "tmp/#{filename}.yml"
      File.open(filename, "w+") do |file|
        file.write(@hash.to_yaml)
      end
      puts "  #{filename}  - created"
    end
  end
end