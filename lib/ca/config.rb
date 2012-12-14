# encoding: utf-8
module Ca
  # Class Ca::Config - Singleton
#################################################
############################### SINGLETON   CLASS
#################################################
  class Config
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
                :google_phrase_lenght

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

      load_from_files()
    end

    # Load data in YAML file to Object fields
    def load_from_files()
      # Stength of each valuable tag specified by number example: h1: 50, b: 5
      @tags_strength = YAML.load_file("config/tags_strength.yaml")
    end
  end
end