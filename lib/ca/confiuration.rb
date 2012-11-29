# encoding: utf-8
module Ca
  # Class Ca::Configuration - Singleton
#################################################
############################### SINGLETON   CLASS
#################################################
  class Configuration
  ##########################################
  # Includes modules
  ##########################################
  include Singleton
  ##########################################
  # Getters and setters
  ##########################################
    attr_reader :tags_strength,
                :phrase_length

  ##########################################
  # Object Methods
  ##########################################
    def initialize()
      # Max length of phrase we choose to analyse text
      @phrase_length = 3
      load_from_files()
    end

    # Load data in YAML file to Object fields
    def load_from_files()
      # Stength of each valuable tag specified by number example: h1: 50, b: 5
      @tags_strength = YAML.load_file("config/tags_strength.yaml")
    end
  end
end