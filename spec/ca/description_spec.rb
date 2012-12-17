# encoding: utf-8
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
        @multiple_description.hash[:ania].frequency.should be 16
      end

      it "position shouldn't be longer than text" do
        @multiple_description.hash[:ania].positions.each {|position| (position < @multiple_words.text.length).should be_true}
      end

      it "simple text analyze shoudl return rigth results" do
        @simple_description.hash[:sample].positions.should be_an Array
        @simple_description.hash[:sample].positions.should == [0, 1, 2]
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
        @description_with_forbidden.hash[:list].positions.should == [0]
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

        @description_with_forbidden.hash[:"list eggs honey"].warning.should be_true
      end

      it "should reconize fine phrases" do
        @description_with_forbidden.hash[:"my mum"].any_warnings?.should be_false
      end
    end

    context "medium length text" do
      before(:all) do
        medium_length_text = Nokogiri::HTML(hard_fixtures["medium_text"])
        @description = Ca::Description.new(medium_length_text)
      end

      it "should reconize warning phrases" do
        @description.hash[:"językowej każdy"].warning.first.forbidden.should be_true
      end

      it "should return nil for każdy couse its on excluded" do
        @description.hash[:każdy].should be nil
      end

    end

    context "img tag without alt analyse" do
      before(:all) do
        empty_alt = Nokogiri::HTML(hard_fixtures["img_without_alt"])
        @img_description = Ca::Description.new(empty_alt)
      end

      it "is object of Ca::Description" do
        @img_description.should be_a Ca::Description
      end
    end

    context "a tag without content analyse" do
      before(:all) do
        @empty_alt = Nokogiri::HTML(hard_fixtures["img_without_alt"])
        @img_description = Ca::Description.new(@empty_alt)
      end

      it "is object of Ca::Description" do
        @img_description.should be_a Ca::Description
      end
    end


    context "stange situations" do
      before(:all) do
        text = Nokogiri::HTML(hard_fixtures[:strange_situations])
        @object = Ca::Description.new(text)
      end
      it "create object for strange situations HTML text" do
        @object.should be_a Ca::Description
      end

      it "should set hash attribute in object" do
        @object.hash.should be_a Hash
      end

      it "sprzątaczka position should be 4" do
        @object.hash[:sprzątaczka].positions.count.should equal 1
        @object.hash[:sprzątaczka].positions.first.should equal 4
      end

      it "tags for sprzątaczka should be div, ol, li" do
        @object.hash[:sprzątaczka].weights.first.should eq [:text, :li, :ol, :div, :body, :html, :document]
      end
    end
  end
end