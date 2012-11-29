# encoding: utf-8
require "spec_helper"

describe :Ca do
  describe :Config do

    context "normal work" do
      it "return phrase length" do
        Ca::Config.instance.phrase_length.should equal 3
      end

      it "keep hash of tags power" do
        Ca::Config.instance.tags_strength.should be_a Hash
      end

      it "keep value 1 for tag <i>" do
        Ca::Config.instance.tags_strength[:i].should equal 1
      end
    end

  end
end