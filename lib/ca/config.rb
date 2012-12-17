# encoding: utf-8
module Ca
  # Class Ca::Config - Singleton
#################################################
############################### SINGLETON   CLASS
#################################################
  class Config
  PATH = "config/"
  ##########################################
  # Includes modules
  ##########################################
  include Singleton
  ##########################################
  # Getters and setters
  ##########################################
    attr_reader :tags_strength,
                :phrase_length,
                :phrase_to_csv,
                :google_phrase_lenght,
                :excluded

  ##########################################
  # Object Methods
  ##########################################
    def initialize()
      # Max length of phrase we choose to analyse text
      @phrase_length = 3
      # Max number of phrases we pass to csv file
      @phrase_to_csv = 100
      # length in words of phrase we parse to google using mechanize in similar_test.rb
      @google_phrase_lenght = 5
      # table od excluded symbols
      @excluded = []

      load_powers()
      load_all_excluded()
    end

    def get_excluded(locale)
      File.read(PATH + "excluded.#{locale}.txt").split.map(&:to_sym)
    end

  ##########################################
  # Private Methods
  ##########################################
  private
    # Load data in YAML file to Object fields
    def load_powers
      # Stength of each valuable tag specified by number example: h1: 50, b: 5
      @tags_strength = YAML.load_file(PATH + "tags_strength.yaml")
    end

    # Load excluded characters from yaml file in /config
    def load_all_excluded
      files = Dir.entries(PATH).keep_if do |file|
        file.match /excluded.[a-z]{2}.txt/
      end
      files.each do |file|
        @excluded += File.read(PATH + file).split.map(&:to_sym)
      end
    end
  end
end