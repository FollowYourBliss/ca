# encoding: utf-8
module Ca
  module Exceptions
    # Class Ca::Exceptions::TagWarnings
    # Parent of all Ca::Exceptions Classes
    class TagWarnings < Exception
  ##########################################
  # Getters
  ##########################################
  # properties - here we collect all warnings symbols (in Array)
      attr_reader :properties

  ##########################################
  # Object methods
  ##########################################
      # Construct initialize @properties by +properties+
      def initialize(properties)
        @properties = properties
      end

      # Method return all classes for HTML tag class
      #   klass #=> "no_need href_empty" for @properties = [:no_need, :href_empty]
      #   klass #=> "classname" for @properties = [:classname]
      def klass
        @properties.map { |symbol|
          symbol.to_s
        }.join(" ") unless @properties.empty?
      end

    end
  end

  # Class TextAnalitics
  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################

    # Method check existing of +attribute+ in +node+, add symbol variables to errors in somethig wrong
    #   Ca::TextAnalitics([], "href", "<a href=""></a>") #=> errors = [:href_empty]
    #   Ca::TextAnalitics([:no_need], "alt", "<img>") #=> errors = [:no_need, :alt_undeclared]
    def self.attribute_check(errors, attribute, node)
      attri = node[attribute]
      if attri.nil?
        errors << "#{attribute}_undeclared".to_sym
      else
        errors << "#{attribute}_empty".to_sym if attri.empty?
      end
    end

    # Return table of problematic classes during node analyse
    def self.problematic_classes
      classes = []
      ["alt", "href", "src"].each do |attribute|
        classes << "#{attribute}_undeclared".to_sym
        classes << "#{attribute}_empty".to_sym
      end
      classes
    end

  end
end