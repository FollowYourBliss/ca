# encoding: utf-8
require "ca/version"
require "nokogiri"

module Nokogiri
  module HTML
    class NodeSpecyfication

      #  Array of tags that we don't use if we out of node
      def self.forbidden_tags
        [:li, :ul, :ol, :tr, :td, :th, :table, :dl, :dt, :dd, :tbody]
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
        tags = tags.dup
        if text.nil?
          return
        end
        if @@last_text.match(text)
          return
        end
        @@counter += description.add(text, tags, @@counter) unless description.nil?
        @@last_text = text

      end

      # Analyze text with Nokogiri and his nodes, use recursion to visit all nodes
      # For every node take it text contents and tags to self.match_tags_to_position
      #   It isn't very important to get return value of this function
      def self.tag_analyzer(node, description, tags=[])
        # Beggining of functions, when we call it without 3rd parameter
        if tags.empty?
          clean
        end
        if node.children.empty?
          tags.push(node.name.to_sym)
          match_tags_to_position(node.text, tags, description)
          node.remove if forbidden_tags.include? tags.last
          tags.pop
        else
          tags.push(node.name.to_sym)
          text = ""

          node.children.each do |child|
            tag_analyzer(child, description, tags)
          end
          if forbidden_tags.include? tags.last
            tags.pop
            node.remove
          else
            match_tags_to_position(node.text, tags, description)
            tags.pop
          end
        end
      end
    private
      # Method clean counter and last_text, we must run this before we start new analyze
      def self.clean
        @@counter = 0
        @@last_text = ""
      end

    end
  end
end