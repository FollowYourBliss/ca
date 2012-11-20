# encoding: utf-8
require "spec_helper"
describe :Nokogiri do
  describe :XML do
    describe :Node do
      context "add node funcionality" do
        before(:each) do
          @document = Nokogiri::XML("<p></p>")
        end

        it "add class to document element if it don't have classes" do
          @document.children.first.add_class("sample")
          @document.css(".sample").first.should be_a Nokogiri::XML::Element
        end

        it "add class to to document element if it have some classes" do
          document = Nokogiri::XML("<p class=\"ada\"></p>")
          document.children.first.add_class("ala")
          document.css(".ada").first.should == document.css(".ala").first
        end
      end
    end
  end
end