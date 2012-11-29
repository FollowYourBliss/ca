# encoding: utf-8
require "spec_helper"

describe :Ca do
  describe :Configuration do

    context "normal work" do
      it "return phrase length" do
        Ca::Configuration.instance.phrase_length.should equal 3
      end

      it "keep hash of tags power" do
        Ca::Configuration.instance.tags_strength.should be_a Hash
      end

      it "keep value 5 for tag <i>" do
        Ca::Configuration.instance.tags_strength[:i].should equal 10
      end
    end

  end
end