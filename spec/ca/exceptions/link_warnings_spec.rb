# encoding: utf-8
require "spec_helper"
describe :Ca do
  describe :TextAnalitics do
    context "LinkWarnings exception raise" do
      before(:all) do
        @correct = Nokogiri::HTML(%q{<a href="a" title="ana">a</a>})
        @uncorrect = Nokogiri::HTML("<a></a>")
      end
      it "reconize correct a tag without raise exception" do
        node = @correct.children.last.children.first.children.first
        expect { Ca::TextAnalitics.a_analyze(node) }.to_not raise_error
      end

      it "reconize uncorrect a tag with raise exception" do
        node = @uncorrect.children.last.children.first.children.first
        expect { Ca::TextAnalitics.a_analyze(node) }.to raise_error(Ca::Exceptions::LinkWarnings)
      end
    end
  end
end