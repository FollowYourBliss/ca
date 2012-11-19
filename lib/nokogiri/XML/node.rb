module Nokogiri
  module XML
    class Node
  ##########################################
  # Object methods
  ##########################################

      # Add additional node with class to Nokogiri::XML::Element(Node)
      #   Nokogiri::XML::Element name="img" attributes=[Nokogiri::XML::Attr name="src" value="www.onet.pl"].add_class("needless") #=>
      #   Nokogiri::XML::Element name="img" attributes=[Nokogiri::XML::Attr name="src" value="www.onet.pl", Nokogiri::XML::Attr name="class" value="needless"]
      def add_class(klass)
        self['class'] = klass if self['class'].nil?
        self['class'] = klass + " " + self['class'] unless self['class'].include? klass
      end
    end
  end
end