# encoding: utf-8
PURE_HTML = "<strong></strong>"
EXAMPLE = "<p>Alex</p>"

require "string_html_remove"
    describe "String method html_remove" do
      it "should return empty string for pure html" do
        PURE_HTML.html_remove.should be_empty
      end

      it "should return right results for simple String" do
        EXAMPLE.html_remove.should match "Alex"
      end
    end