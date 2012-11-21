# encoding: utf-8
require "spec_helper"

describe :Ca do
  describe :Analyse do
    context "during normal work" do
      it "should create new Ca::Analyse Object" do
        Ca::Analyse.new("Ala ma kota").should be_an Ca::Analyse
      end

      it "should store Description Object" do
        Ca::Analyse.new("Ala ma kota").description.should be_an Ca::Description
      end
    end

    context "Vary long Lore ipsum" do
      it "should create new Ca::Analyse Object" do
        Ca::Analyse.new(hard_fixtures["long_ipsum"]).should be_an Ca::Analyse
      end
    end

  end
end