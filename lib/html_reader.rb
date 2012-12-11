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


  # Load HTML file and return string table from spec/fixtures/ with html extension
  def fixtures(url)
    open("spec/fixtures/#{url}.html", "User-Agent" => user_agent)
  end

  def page(href)
    open(href, "User-Agent" => user_agent)
  end

  def url(url)
    open(url)
  end

  def user_agent
    "HTTP_USER_AGENT:Mozilla/5.0"
  end
end
