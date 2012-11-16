# encoding: utf-8
require "spec_helper"

examples = hard_fixtures[:string_html_remove]

    describe "String method html_remove" do

      it "should return empty string for pure html" do
        examples[:pure_html].html_remove.should be_empty
      end

      it "should return right results for simple String" do
        examples[:common_example].html_remove.should match "paproszki"
      end
    end

    describe "String method nr_of_words" do
      it "should return correct number of words for example phrases" do
        examples[:common_example].nr_of_words.should be 1
        examples[:pure_html].nr_of_words.should be 0
      end
    end