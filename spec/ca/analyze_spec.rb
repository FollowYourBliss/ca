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
        @analyse.description.hash[:and].frequency.should eql 5
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
        @analyse.should_not be_false
      end

      it "hash has be like" do
        hash = @analyse.description.hash
        hash[:"of best"].frequency.should be 1
        hash[:"applications rails"].weights.first.should eq [:p, :div, :body, :html, :document]
        hash[:see].frequency.should be 1
      end

    end

    context "another encoding" do
      before(:all) do
        @analyse = Ca::Analyse.new(HTMLReader.instance.fixtures("another_coding"))
      end

      it "can interpret another encoding" do
        hash = @analyse.description.hash
        hash[:"wydział fizyki"].should_not be nil
        hash[:"zaprzestał prowadzenia własnej"].frequency.should be 1
      end

    end


    context "seo long text " do
      before(:all) do
        @analyse = Ca::Analyse.new(HTMLReader.instance.fixtures("seo_text"))
      end

      it "can interpret long text correctly" do
        hash = @analyse.description.hash
        hash[:pozycjonowanie].frequency.should be 13
      end

    end

    # context "pajacyk.pl online analyse" do
    #   before(:all) do
    #     @analyse = Ca::Analyse.new(HTMLReader.instance.page("http://www.pajacyk.pl"))
    #   end

    #   it "create object" do
    #     @analyse.should_not be nil
    #   end
    # end

    # context "di.com.pl article" do
    #   pending "temporarily disabled"
    #   before(:all) do
    #     @analyse = Ca::Analyse.new(HTMLReader.instance.page("http://di.com.pl/news/47068,0,Della_pokochaja_uzytkownicy_Linuksa_Nowy_ultrabook_z_Ubuntu_jest_genialny-Adrian_Nowak.html"))
    #   end

    #   it "create object" do
    #     @analyse.should_not be nil
    #   end
    # end

    context "analyse strange situations" do
      before(:all) do
        @analyse = Ca::Analyse.new(hard_fixtures[:strange_situations2])
      end

      it "correctly set frequency" do
        hash = @analyse.description.hash
        hash[:first].frequency.should eq 1
      end


      it "correctly set weights" do
        hash = @analyse.description.hash
        hash[:first].weights.should eq [[:text, :li, :ol, :body, :html, :document]]
      end
    end



  end
end