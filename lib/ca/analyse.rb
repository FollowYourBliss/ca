# encoding: utf-8
module Ca
  # Class Anazyse
  class Analyse

  ##########################################
  # Getters
  ##########################################
    attr_reader :description

  ##########################################
  # Object methods
  ##########################################
    # Construct. Build Description Object based on +text+
    def initialize(text)
      nokogiri_stucture = Nokogiri::HTML(text)
      @description = Ca::Description.new(nokogiri_stucture)
      self
    end

  end
end