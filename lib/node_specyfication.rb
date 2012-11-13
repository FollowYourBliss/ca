# encoding: utf-8
require "ca/version"
require "nokogiri"

module Nokogiri
  module HTML
    class NodeSpecyfication
        # Contruct initialize some of class variables
        def self.initialize
          clean
        end

        # Method fill descritption Object with values from self.tag_analyzer
        def self.match_tags_to_position(text, tags, description)
          if text.nil?
            return
          end
          if @@last_text.match(text)
            return
          end
          p description.hash
          @@counter = @@counter + description.add(text, tags, @@counter) unless description.nil?
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
            tags.pop
            return tags
          else
            tags.push(node.name.to_sym)
            text = ""

            node.children.each do |child|
              tag = tag_analyzer(child, description, tags)
            end
            match_tags_to_position(node.text, tags, description)
            tags.pop
            return tags
          end

        end

        def self.clean
          @@counter = 0
          @@last_text = ""
        end

    end
  end
end