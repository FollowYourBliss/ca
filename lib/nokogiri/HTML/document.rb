# encodint: utf-8
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
      end
    end
  end
end