# encoding: utf-8
require "ca/exceptions/tag_warnings"
module Ca
  module Exceptions
    # Class Ca::Exceptions::LinkWarning
    # Exception we throw when it is a problem with <a> tag
    class LinkWarnings < TagWarnings
    end
  end

  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################
    # Method to analyze HTML <a> tag, collect errors, and if there are any raise LinkWarnings with this errors
    #   a_analyze("<a title="title" href="href">Link</a>") #=> don't raise exception
    #   a_analyze("<a href="href"></a>") #=> raise LinkWarnings([:content_empty, :title_undeclared])
    def self.a_analyze(node)
      errors = []
      errors << :content_empty if node.children.empty?
      # Add attributes you want to check here
      ["title", "href"].each do |attribute|
        # attribute check is in tag_warning.rb
        attribute_check(errors, attribute, node)
      end
      raise Ca::Exceptions::LinkWarnings.new(errors) unless errors.empty?
    end
  end

end