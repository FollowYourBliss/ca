# encoding: utf-8
require "spec_helper"

describe :Ca do
  describe :Analyse do
    context "during normal work" do
      it "should create new Ca::Analyse Object" do
        Ca::Analyse.new("Ala ma kota").should be_an Ca::Analyse
      end

      it "should store Description Object" do
        Ca::Analyse.new("Ala ma kota").description.should be_a Ca::Description
      end
    end

    context "Vary long Lore ipsum" do
      it "should create new Ca::Analyse Object" do
        Ca::Analyse.new(hard_fixtures["long_ipsum"]).should be_an Ca::Analyse
      end
    end

    context "Ubuntu text analyse" do
      before(:all) do
        @analyse = Ca::Analyse.new(hard_fixtures["ubuntu_article"])
      end

      it "is an Object of Ca::Analyse" do
        @analyse.should be_a Ca::Analyse
      end

      it "have Finxum 10 in frequency field of :and key" do
        @analyse.description.hash[:and].frequency.should eql 9
      end

      it "have Featrue for :'releases every' key" do
        @analyse.description.hash.has_key? "releases every".to_sym
      end
    end

    context "ruby on rails documentation" do
      before(:all) do
        @analyse = Ca::Analyse.new(HTMLReader.instance.fixtures("ror_documentation"))

      end

      it "isn't empty Object" do
        @analyse.description.display_keys
        @analyse.should_not be_false
      end

    end

  end
end