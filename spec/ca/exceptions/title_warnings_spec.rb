# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :TextAnalitics do
    context "TitleWarning exception raise" do
      before(:all) do
        @correct = Nokogiri::HTML(%q{<title>Title</title>})
        @uncorrect = Nokogiri::HTML("<title></title>")
      end
      it "reconize correct img tag without raise exception" do
        node = @correct.children.last.children.first.children.first
        expect { Ca::TextAnalitics.title_analyze(node) }.to_not raise_error
      end

      it "reconize uncorrect img tag with raise exception" do
        node = @uncorrect.children.last.children.first.children.first
        expect { Ca::TextAnalitics.title_analyze(node) }.to raise_error(Ca::Exceptions::TitleWarnings)
      end
    end
  end
end