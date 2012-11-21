# encoding: utf-8
require "spec_helper"
example = hard_fixtures[:features]
descriptions = hard_fixtures[:description]

describe :Ca do
  describe :Features do
    context "during normal work" do

      before(:each) do
        @features = Ca::Features.new
        @features.update(example[:weight], example[:position], example[:length])
      end

      it "should be able to share arguments throught accessor" do
        @features.frequency.should be 1
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

      it "update method should change frequency field, weights field and positions field" do
        last_frequency = @features.frequency
        @features.update("tags", 69, 1)
        @features.frequency.should be > last_frequency
        @features.weights.last.include?("tags").should be_true
        @features.positions.include?(69).should be_true
      end


    end
  end
end
