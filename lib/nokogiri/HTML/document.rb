# encoding: utf-8
module Nokogiri
  module HTML
    # Class Nokogiri::HTML::Document
    class Document
      # Remove unnecessary tags and elements from HTML text analyse
      def remove_unnecessary
        xpath('//comment()').remove
        xpath("//script").remove
        xpath("//noscript").remove
        xpath("//style").remove
        xpath("//link").remove
        xpath("//style").remove
        xpath('//processing-instruction()').remove
      end
      # Method that return true if HTML document have only one or zero h1 tag
      # return false if there are more than 1 h1 tag
      def one_h1?
        xpath("//h1").count.between?(0, 1)
      end

      # Return true if tag meta description is empty
      def empty_meta_description?
        return meta_empty?("description")
      end


      # Return true if tag meta description is empty
      def empty_meta_keywords?
        return meta_empty?("keywords")
      end

      # Return number of chars in HTML text
      def number_of_chars
        text.to_s.number_of_chars
      end

      # Function that check meta tags by name of them
      def meta_empty?(name)
        tag = css("meta[name='#{name}']")
        return true if tag.nil? or tag.empty?
        return true if tag.first['content'].empty?
        false
      end

      # Function that check title
      # return false if everyfing is ok
      def empty_title?
        tag = xpath("//title")
        return true if tag.nil? or tag.empty?
        return true if tag.children.empty?
        false
      end
    end
  end
end