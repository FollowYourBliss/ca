# encoding: utf-8
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
          :ol,
          :tr,
          :td,
          :th,
          :table,
          :dl,
          :dt,
          :dd
        ]
      end

      # Return true if any of @weigths field from Da::Features contains forbidden_tags
      def self.forbidden?(one_of_weigths)
        not (one_of_weigths & forbidden_tags).empty?
      end

      # Method fill descritption Object with values from self.tag_analyzer
      # Main call is to description.add(args)
      # We skip empty text and situations when present text was the same as the previous
      # As arguments we use +text+ - String of phrase we describe
      #                     +tags+ - HTML tags for this phrase
      #                     +description+ - Ca::Description Object that we change
      def self.match_tags_to_position(text, tags, description)
        return if text.nil?
        description.add(text, tags, @@counter) unless description.nil?
      end

      # Analyze text with Nokogiri and his nodes, use recursion to visit all nodes
      # For every node take it text contents and tags to self.match_tags_to_position
      #   It isn't very important to get return value of this function
      def self.tag_analyzer(node, description, tags = [])
        @@counter = 0 if tags.empty?
        tag = node.name.to_sym
        along_childrens(node.children, description, tag)
        single_node(node, tag, description)
        node.surround if tag == :text
      end
  ##########################################
  # Private methods
  ##########################################
    private
      # Loop along all childrens
      def self.along_childrens(childrens, description, tag)
        childrens.each do |child|
          tag_analyzer(child, description, tag)
          text = child.text
          text = text.without_garbage if text
          @@counter += text.nr_of_words unless (text.nil?) or (child.name == "text")
        end
      end

      # Analyse of single node without his children (in program flow children are analyzed before)
      def self.single_node(node, tag, description)
        text = node.text
        text = text.without_garbage if text
        has_children, words_count = node.children.empty?, (text ? text.nr_of_words : 0)
        @@counter -= words_count unless has_children
        match_tags_to_position(text, tag, description)
        @@counter += words_count if text and has_children
        Ca::NodeCounter.instance.increment
      end

    end


  end
end