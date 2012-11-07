# encoding: utf-8
require "features"
require "spec_helper"
require "nokogiri"
require "open-uri"
example = hard_fixtures[:features]

describe :Ca do
  describe :Features do
    context "during normal work" do

      before(:all) do
        @features = Ca::Features.new(example[:hash], example[:key], example[:text_array])
      end

      it "should be able to share arguments throught accessor" do
        @features.frequency.should be 2
        @features.positions.should be_a Array
        @features.weights.should be_a Array
        @features.words_count.should be 2
      end

      it "should find positions" do
        @features.positions.should be_true
        @features.positions.count.should be 1
      end

      it "should find position on right place" do
        @features.positions.first.should be 0
      end


    end

    context "nokogiri chceck" do
      before(:all) do
        @nokogiri_structure = Nokogiri::HTML(hard_fixtures["nokogiri"])
      end

      it "should open page from yaml file" do
        @nokogiri_structure.should_not be nil
      end

      it "should barking" do
        Nokogiri::HTML::NodeSpecyfication.bark.should match "Hau"
      end



    end
  end
end
