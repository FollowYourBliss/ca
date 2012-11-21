module Nokogiri::XML
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
        space = Nokogiri::XML::Text.new(" ", self)
        self.before(space)
        self.after(space)
      end
    end
end