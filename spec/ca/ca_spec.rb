# encoding: utf-8
require "ca"
TEXT = "Lorem Lorem ipsum dolor sit amet, na na na na na na Foo Bar consectetur adipiscing-elit. Quisque Foo Bar ac nisi nunc, sit amet commodo mi. Nunc velit tellus, malesuada vitae vehicula a, imperdiet sed nisi."
PL_TEXT = "Litwo! Ojczyzno moja! Ty jesteś jak zdrowie. Nazywał się kojarz wspaniały domów sojusz - mawiał - rzekł na kształt ogrodowych grządek:"
HTML_TEXT = "<p>Lorem ipsum dolor sit amet tellus. Vestibulum ante felis, feugiat quam placerat id, nunc. Ut pharetra elementum. Fusce eu eros. Maecenas tortor venenatis in, convallis diam at arcu ac eros ac eros. Ut sodales, dictum vel, pellentesque eget, molestie justo euismod mi. Suspendisse rutrum magna suscipit enim. Duis a luctus diam. Donec elementum orci luctus quam at augue. Maecenas eget orci sit amet, tempor diam. Proin scelerisque rhoncus a, pellentesque auctor congue quis, tincidunt at, mauris. Pellentesque egestas dignissim, sapien sed nunc ut tellus porttitor ullamcorper, enim sed tortor. Ut tempus ipsum. Vestibulum ante ipsum primis in orci luctus et magnis dis parturient montes, nascetur ridiculus mus. Fusce condimentum magna dictum eu, commodo ipsum ac nibh massa quis leo. Ut aliquet, lacus lacus sed viverra accumsan. Fusce urna luctus tellus tortor, fermentum in, elementum consequat. Aliquam nonummy, mi. Cras sit amet dui at justo. Vivamus hendrerit tellus consectetuer elit. Nunc elementum. Fusce interdum. Donec suscipit lectus. Vivamus a metus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Sed metus hendrerit laoreet. Nam ac turpis mauris.</p>"


describe :Ca do
  describe :TextAnalitics do

    context "analyse exemplary text with one word for English text" do

      before(:all) do
        @result = Ca::TextAnalitics.analize(TEXT)
      end

      it "method analize should return Hash" do
        @result.first.should be_a(Hash)
      end

      it "method analize should return Hash with length > 0" do
        @result.first.length.should be > 0
      end

      it "method analize shoudl return value 2 for 'Lorem' hash key" do
        @result.first["Lorem"].should be(2)
      end

    end


    context "analize exemplary text with dwo words in phrase for English text" do

      before(:all) do
        @result = Ca::TextAnalitics.analize(TEXT, 2)
      end

      it "method analize should return Hash" do
        @result.first.should be_a Hash
      end

      it "method analize should return value 2 for 'Foo Bar' hash key" do
        @result.first["Foo Bar"].should be 2
      end

      it "method analize should return value 1 for 'a' hash key" do
        @result.first["a"].should be 1
      end
    end

    context "analyse exemplary text with three words in phrase for English text" do

      before(:all) do
        @result = Ca::TextAnalitics.analize(TEXT, 3)
      end

      it "method analize should return Hash" do
        @result.first.should be_a Hash
      end

      it "method analize should return 2 for 'na na na'" do
        @result.first["na na na"].should be 4
      end

      it "method analize should return 3 for 'na na'" do
        @result.first["na na"].should be 5
      end
    end

    context "analyse exemplary text with one word in phrase for Polish text" do

      before(:all) do
        @result = Ca::TextAnalitics.analize(PL_TEXT)
      end

      it "method analize should return Hash" do
        @result.first.should be_a Hash
      end

      it "method analize should return 1 for 'domów'" do
        @result.first["domów"].should be 1
      end

      it "method analize should return Hash with length > 0" do
        @result.first.length.should be > 0
      end


    end

    context "phrases generation" do
      before(:all) do
        nokogiri_structure = Nokogiri::HTML(hard_fixtures["nokogiri"])
        @result = Ca::TextAnalitics.phrases(hard_fixtures["nokogiri"].html_remove, 3)
      end

      it "should generate correct phreses" do
        p "pływajace labedzie"
        p @result

      end
    end


  end

end