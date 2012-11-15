# encoding: utf-8
require "spec_helper"
describe :Nokogiri do
  describe :HTML do
    describe :NodeSpecyfication do
      context "node_specyfication class functionality" do
        before(:each) do
          @match_sample = hard_fixtures[:matching]
          @nokogiri_structure = Nokogiri::HTML(hard_fixtures["nokogiri"])
          @nokogiri_extension = Nokogiri::HTML::NodeSpecyfication.new
          @description = Ca::Description.new(@nokogiri_structure)
        end

        it "should return table of \"forbidden\" html tags" do
          Nokogiri::HTML::NodeSpecyfication.forbidden_tags.should be_a(Array)
        end

        it "initializer is static" do
          Nokogiri::HTML::NodeSpecyfication.new
        end

        it "clean method is static" do
          Nokogiri::HTML::NodeSpecyfication.clean
        end

        it "fill description model with informations from analyze" do

        end

        it "should open page from yaml file" do
          @nokogiri_structure.should_not be nil
        end

        it "tag_analyzer return Symbol (last tag)" do
          Nokogiri::HTML::NodeSpecyfication.tag_analyzer(@nokogiri_structure, @description).should be_a Symbol
        end

        it "match tag to position should return String (last text)" do
          Nokogiri::HTML::NodeSpecyfication.match_tags_to_position(@match_sample[:text], @match_sample[:tags], @description).should be_a String
        end

      end
    end
  end
end