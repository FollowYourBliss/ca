# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :TextAnalitics do
    context "ImgWarning exception raise" do
      before(:all) do
        @correct = Nokogiri::HTML(%q{<img src="src" title="ko" alt="sample">})
        @uncorrect = Nokogiri::HTML("<img/>")
      end
      it "reconize correct img tag without raise exception" do
        node = @correct.children.last.children.first.children.first
        expect { Ca::TextAnalitics.img_analyze(node) }.to_not raise_error
      end

      it "reconize uncorrect img tag with raise exception" do
        node = @uncorrect.children.last.children.first.children.first
        expect { Ca::TextAnalitics.img_analyze(node) }.to raise_error(Ca::Exceptions::ImgWarnings)
      end
    end
  end
end