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

    context "create excluded table" do
      it "create table of symbols" do
        Ca::Config.instance.excluded.should be_an Array
      end

      it "elements are Symbols" do
        Ca::Config.instance.excluded.all? {|elem| elem.class == Symbol}.should be_true
      end

    end

  end
end