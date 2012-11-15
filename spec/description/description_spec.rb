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
        p "Simple Words #{hard_fixtures["simple_words"]}"
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
        p @simple_description
        @simple_description.hash[:Sample].positions.should be_an Array
        @simple_description.hash[:Sample].positions.should == [0, 1, 2]
      end


    end
  end
end