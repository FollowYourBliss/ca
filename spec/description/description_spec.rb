# encoding: utf-8
require "description"
require "spec_helper"

example = hard_fixtures[:description]
describe :Ca do
  describe :Description do
    context "during normal work" do

      before(:all) do
        @description = Ca::Description.new(example)
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

    end
  end
end