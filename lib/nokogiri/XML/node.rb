module Nokogiri
  module XML
    # Class Nokogiri::XML::Node
    class Node
  ##########################################
  # Object methods
  ##########################################

      # Add additional node with class to Nokogiri::XML::Element(Node)
      #   Nokogiri::XML::Element name="img" attributes=[Nokogiri::XML::Attr name="src" value="www.onet.pl"].add_class("needless") #=>
      #   Nokogiri::XML::Element name="img" attributes=[Nokogiri::XML::Attr name="src" value="www.onet.pl", Nokogiri::XML::Attr name="class" value="needless"]
      def add_class(klass)
        class_attribute = self['class']
        self['class'] = (class_attribute.nil?) ? klass : (klass + " " + class_attribute)
      end

      # Add spaces before and after Nokogiri::XML::Element(Node)
      def surround
        self.before(Nokogiri::XML::Text.new(" ", self))
        self.after(Nokogiri::XML::Text.new(" ", self))
      end

      # Replace <br/> tags with " "
      # self.replace don't work - segmentation fault, so I change it to self.after
      # it work same good
      def eliminate_br
        self.after(Nokogiri::XML::Text.new(" ", self))
      end
    end
  end
end