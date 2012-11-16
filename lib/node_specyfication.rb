# encoding: utf-8
require "ca/version"
require "nokogiri"

module Nokogiri
  module HTML
    class NodeSpecyfication

      # Array of tags that we don't use if we out of node
      def self.forbidden_tags
        [:li, :ul, :ol, :tr, :td, :th, :table, :dl, :dt, :dd, :tbody]
      end

      # Return true if any of @weigths field from Da::Features contains forbidden_tags
      def self.forbidden?(one_of_weigths)
        not (one_of_weigths & forbidden_tags).empty?
      end

      # In constructor we initialize same of class variables by call clean self method
      def self.initialize
        clean
      end

      # Method fill descritption Object with values from self.tag_analyzer
      # Main call is to description.add(args)
      # We skip empty text and situations when present text was the same as the previous
      # As arguments we use +text+ - String of phrase we describe
      #                     +tags+ - HTML tags for this phrase
      #                     +description+ - Ca::Description Object that we change
      def self.match_tags_to_position(text, tags, description)
        if text.nil?
          return
        end
        description.add(text, tags, @@counter) unless description.nil?
      end

      # Analyze text with Nokogiri and his nodes, use recursion to visit all nodes
      # For every node take it text contents and tags to self.match_tags_to_position
      #   It isn't very important to get return value of this function
      def self.tag_analyzer(node, description, tags=[])
        # Beggining of functions, when we call it without 3rd parameter
        if tags.empty?
          clean
        end
        tag = node.name.to_sym
        if node.children.empty?
          match_tags_to_position(node.text, tag, description)
          @@counter += node.text.nr_of_words if node.text
          if forbidden_tags.include? tag
            @@counter -= node.text.nr_of_words if node
            node.before(Nokogiri::XML::Text.new(" ", node))
            node.after(Nokogiri::XML::Text.new(" ", node))
          end
        else
          node.children.each do |child|
            tag_analyzer(child, description, tag)
            @@counter += child.text.nr_of_words unless (child.text.nil?) or (child.name == "text")
          end
          @@counter -= node.text.nr_of_words
          match_tags_to_position(node.text, tag, description)
          if forbidden_tags.include? tag
            node.before(Nokogiri::XML::Text.new(" ", node))
            node.after(Nokogiri::XML::Text.new(" ", node))
          end
        end
      end
    private
      # Method clean counter, we must run this before we start new analyze
      def self.clean
        @@counter = 0
      end

    end
  end
end