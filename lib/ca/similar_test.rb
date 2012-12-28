# encoding: utf-8
module Ca
  # Class Ca::SimilarTest
  class SimilarTest

    attr_reader :result


  ##########################################
  # Class methods
  ##########################################
   # Analyse +search_results+ from Mechanize, parse to Nokogiri, fetch only description and tokenize. Then compare with pattern +phraze+
    def analyse_result(search_result, phrase)
        search_table = search_result.parser.xpath("//span[@class='st']").text.without_garbage.down_case.split
        phrase_table = phrase.split
        @result = (search_table & phrase_table).count > (Ca::Config.instance.google_phrase_lenght - 2)
    end

    # Contruct, get +text+ to analyse if it is any similar texts in net
    # Set main flags
    def initialize(text)
      @text = text
      @nr_of_words = @text.nr_of_words
      @phrase_length = Ca::Config.instance.google_phrase_lenght
      @result = false
    end

    # Runs searching process
    # if nr_of_words lower than phrase_length we does nothing
    def run
      searching if @nr_of_words >= @phrase_length
    end

    # Fill Array of random phrases and return it
    def prepare_phrases
      text_array, prepared = @text.split, []
      3.times do |time|
        prepared << random_phrase(text_array)
      end
      prepared
    end

    # Make random phrase from table of strings
    def random_phrase(text_array)
      enable_start = @nr_of_words - @phrase_length
      start = rand(0..enable_start)
      text_array[start..(start+@phrase_length)].join(" ")
    end


    # Main search method, runs searching_single method for every phrase in prepare_phrases method return
    def searching
      prepare_phrases.each do |phrase|
        searching_single(phrase)
      end
    end

    # Single phrase analise, run static method
    def searching_single(phrase)
        analyse_result(Ca::SimilarTest.mechanize_work(phrase), phrase)
    end

    # Using Mechanize go to htpp://www.google.com, parse phrase and sumbit
    def self.mechanize_work(phrase)
        agent = Mechanize.new
        page = agent.get("http://www.google.com")
        page.encoding = 'utf-8'
        search_form = page.form_with(name: "f")
        search_form.field_with(name: "q").value = phrase
        agent.submit(search_form)
    end

  end
end

