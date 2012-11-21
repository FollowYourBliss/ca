# encoding: utf-8
require "nokogiri"
require "nokogiri/XML/node"
module Nokogiri
  module HTML
    # Class Nokogiri::HTML::NodeSpecyfication
    class NodeSpecyfication

  ##########################################
  # Class methods
  ##########################################

      # Array of tags that we don't use if we out of node
      def self.forbidden_tags
        [
          :li,
          :ul,
          :ol,
          :tr,
          :td,
          :th,
          :table,
          :dl,
          :dt,
          :dd,
          :tbody
        ]
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
      def self.match_tags_to_position(text, tags, description, words_count)
        return if text.nil?
        p "Text: #{text} Counter #{@@counter}"
        description.add(text, tags, @@counter) unless description.nil?
      end

      # Analyze text with Nokogiri and his nodes, use recursion to visit all nodes
      # For every node take it text contents and tags to self.match_tags_to_position
      #   It isn't very important to get return value of this function
      def self.tag_analyzer(node, description, tags = [])
        @@counter = 0 if tags.empty?
        tag = node.name.to_sym


        children = node.children
        along_childrens(children, description, tag)
        text = node.text
        has_children, words_count = children.empty?, (text ? text.nr_of_words : 0)
        @@counter -= words_count unless has_children
        match_tags_to_position(text, tag, description, words_count)
        @@counter += words_count if text and has_children

        if forbidden_tags.include? tag
          node.surround
        end


      end
  ##########################################
  # Private methods
  ##########################################
    private

      def self.along_childrens(childrens, description, tag)
        childrens.each do |child|
          subtext = child.text
          tag_analyzer(child, description, tag)
          @@counter += subtext.nr_of_words unless (subtext.nil?) or (child.name == "text")
        end
      end
    end
  end
end