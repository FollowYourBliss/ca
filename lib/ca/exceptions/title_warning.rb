# encoding: utf-8
require "ca/exceptions/tag_warnings"
module Ca
  module Exceptions
    # Class Ca::Exceptions::TitleWarnings
    # Exception we throw when there is a problem with <title> tag
    class TitleWarnings < TagWarnings
    end
  end

  # Class TextAnalitics
  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################
    # Method to analyze HTML <title> tag, collect errors, and if there are any raise TitleWarnings with this errors
    #   img_analyze("<title>Title</title>") #=> don't raise exception
    #   img_analyze("<title></title>") #=> raise TitleWarnings([:content_empty])
    def self.title_analyze(node)
      errors = []
      errors << :content_empty if node.children.empty?
      raise Ca::Exceptions::TitleWarnings.new(errors) unless errors.empty?
    end
  end
end