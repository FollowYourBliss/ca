# encoding: utf-8
module Ca
  # Class Ca::Anazlyse
  # Main gem Class, run most important commands
  class Analyse

  ##########################################
  # Getters
  ##########################################
    attr_reader :description

  ##########################################
  # Object methods
  ##########################################
    # Construct. Build Description Object based on +text+
    #   Ca::Analyse.new("<b>Sample</b>")
    #   Ca::Analyse.new("<br/>Nothing to loose<br/>")
    def initialize(text, phrase_length = Ca::Config.instance.phrase_length)
      nokogiri_structure = Nokogiri::HTML(text)
      nokogiri_structure.remove_unnecessary
      @description = Ca::Description.new(nokogiri_structure, phrase_length)
      self
    end
  end
end