# encoding: utf-8
  # Class HTMLReader - Singleton
#################################################
############################### SINGLETON   CLASS
#################################################
class HTMLReader
##########################################
# Includes modules
##########################################
include Singleton
##########################################
# Getters
##########################################
  attr_reader :url

##########################################
# Object Methods
##########################################

  def initialize
    @start = 1
  end
  # Load HTML file and resturn string table
  def fixtures(url)
    IO.read("spec/fixtures/#{url}.html")
  end
end
