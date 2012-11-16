# encoding: utf-8
require "description"
require "spec_helper"

# Here we test all the articles
multiple_words = hard_fixtures["multiple_words"]

describe :Ca do
  describe :Description do
    context "during normal work" do

      before(:all) do
        @multiple_words = Nokogiri::HTML(multiple_words)
        nokogiri_structure = Nokogiri::HTML(hard_fixtures["julia_sample"])
        @description = Ca::Description.new(nokogiri_structure)
        @multiple_description = Ca::Description.new(@multiple_words)
        simple_words = Nokogiri::HTML(hard_fixtures["simple_words"])
        @simple_description = Ca::Description.new(simple_words)
      end

      it "should be able to share arguments throught accessor" do
        @description.hash.should be_a(Hash)
      end

      it "should trow exection when we want to write value into hash argument" do
        @description.hash.store("virus", "bug").should raise_error
      end

      it "shouldn't create empty hash" do
        @description.hash.empty?.should_not be true
      end

      it "should find only 16 occurs of word 'Ania'" do
        @multiple_description.hash[:Ania].frequency.should be 16
      end

      it "position shouldn't be longer than text" do
        @multiple_description.hash[:Ania].positions.each {|position| (position < @multiple_words.text.length).should be_true}
      end

      it "simple text analyze shoudl return rigth results" do
        @simple_description.hash[:Sample].positions.should be_an Array
        @simple_description.hash[:Sample].positions.should == [0, 1, 2]
      end




    end

    context "text with forbidden tags" do
      before(:all) do
        text_with_forbidden = Nokogiri::HTML(hard_fixtures["forbidden_tags"])
        @description_with_forbidden = Ca::Description.new(text_with_forbidden)
      end

      it "should return hash named by text in forbidden tags" do
        @description_with_forbidden.hash.has_key?(:eggs).should be_true
      end

      it "should return correct positions for text outsite the forbidden tags" do
        @description_with_forbidden.hash[:List].positions.should == [0]
      end

      it "should add forbidden tags into tags of phrase" do
        @description_with_forbidden.hash[:eggs].weights.first.should include(:li)
      end

      it "can't stick words from outside the forbiddent tags" do
        @description_with_forbidden.hash.should_not include(:Listend)
      end

      it "should place phrase in the right position" do
        @description_with_forbidden.hash[:end].positions.should include(3)
      end

      it "should reconize warnings phrases" do
        @description_with_forbidden.hash[:"List eggs honey"].warning.should be_true
      end

      it "should reconize fine phrases" do
        @description_with_forbidden.hash[:"My mum"].warning.at(0).should be_false
      end

    end
  end
end