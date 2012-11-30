# encoding: utf-8
require "spec_helper"

TEXT = "Lorem Lorem ipsum dolor sit amet, na na na na na na Foo Bar consectetur adipiscing-elit. Quisque Foo Bar ac nisi nunc, sit amet commodo mi. Nunc velit tellus, malesuada vitae vehicula a, imperdiet sed nisi."
PL_TEXT = "Litwo! Ojczyzno moja! Ty jesteś jak zdrowie. Nazywał się kojarz wspaniały domów sojusz - mawiał - rzekł na kształt ogrodowych grządek:"
HTML_TEXT = "<p>Lorem ipsum dolor sit amet tellus. Vestibulum ante felis, feugiat quam placerat id, nunc. Ut pharetra elementum. Fusce eu eros. Maecenas tortor venenatis in, convallis diam at arcu ac eros ac eros. Ut sodales, dictum vel, pellentesque eget, molestie justo euismod mi. Suspendisse rutrum magna suscipit enim. Duis a luctus diam. Donec elementum orci luctus quam at augue. Maecenas eget orci sit amet, tempor diam. Proin scelerisque rhoncus a, pellentesque auctor congue quis, tincidunt at, mauris. Pellentesque egestas dignissim, sapien sed nunc ut tellus porttitor ullamcorper, enim sed tortor. Ut tempus ipsum. Vestibulum ante ipsum primis in orci luctus et magnis dis parturient montes, nascetur ridiculus mus. Fusce condimentum magna dictum eu, commodo ipsum ac nibh massa quis leo. Ut aliquet, lacus lacus sed viverra accumsan. Fusce urna luctus tellus tortor, fermentum in, elementum consequat. Aliquam nonummy, mi. Cras sit amet dui at justo. Vivamus hendrerit tellus consectetuer elit. Nunc elementum. Fusce interdum. Donec suscipit lectus. Vivamus a metus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos hymenaeos. Sed metus hendrerit laoreet. Nam ac turpis mauris.</p>"


describe :Ca do
  describe :TextAnalitics do
    context "phrases generation" do
      before(:all) do
        nokogiri_structure = Nokogiri::HTML(hard_fixtures["nokogiri"])
        @result = Ca::TextAnalitics.phrases(hard_fixtures["nokogiri"].html_remove, 3)
      end

      it "should generate correct phreses" do
        @result.should be_true
      end
    end

    context "Tag a analyse" do
      it "raise error if a content is empty" do
        expect { Ca::TextAnalitics.node_attributes_analyze(Nokogiri::HTML("<a></a>").children.last.children.last.children.first)}.to raise_error
      end

      it "don't raise error if a content is not empty" do
        expect { Ca::TextAnalitics.node_attributes_analyze(Nokogiri::HTML(%q{"<a href="link.com" title="title">Link</a>"}).children.last.children.last.children.first)}.to_not raise_error
      end
    end

    context "Tag img analyse" do
      it "raise error if a content is empty" do
        expect { Ca::TextAnalitics.node_attributes_analyze(Nokogiri::HTML("<img>").children.last.children.last.children.first)}.to raise_error
      end

      it "don't raise error if a content is not empty" do
        expect { Ca::TextAnalitics.node_attributes_analyze(Nokogiri::HTML(%q{<img alt="alt" src="koko" title="title">}).children.last.children.last.children.first)}.to_not raise_error
      end
    end


  end

end