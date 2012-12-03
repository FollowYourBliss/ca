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
    open("spec/fixtures/#{url}.html", "User-Agent" => user_agent)
  end

  def page(href)
    open(href, "User-Agent" => user_agent)
  end

  def user_agent
    "HTTP_USER_AGENT:Mozilla/5.0 (Windows; U; Windows NT 6.0;
en-US) AppleWebKit/534.13 (KHTML, like Gecko) Chrome/9.0.597.47"
  end
end
