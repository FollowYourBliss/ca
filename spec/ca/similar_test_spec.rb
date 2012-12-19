# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :SimilarTest do

    context "Could find text in internet resources" do
      before(:all) do
        text = "ruby on rails free gems linux webs"
        @test = Ca::SimilarTest.new(text)
        @test.run
      end

      it "Object should be a Ca::SimilarTest object" do
        @test.should be_a Ca::SimilarTest
      end

      it "return true value for exising phrases" do
        @test.result.should be_true
      end
    end

    context "Couldn't find text in internet resources" do
      before(:all) do
        text = "Gupy poszła gdzieś kopać mechanikę"
        @test = Ca::SimilarTest.new(text)
        @test.run
      end

      it "Object should be a Ca::SimilarTest object" do
        @test.should be_a Ca::SimilarTest
      end

      it "return true value for exising phrases" do
        @test.result.should be_false
      end

    end
  end
end