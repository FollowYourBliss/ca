# encoding: utf-8
require "ca/exceptions/tag_warnings"
module Ca
  module Exceptions
    # Class ImgWarnings
    class ImgWarnings < TagWarnings
    end
  end

  # Class TextAnalitics
  class TextAnalitics
  ##########################################
  # Class methods
  ##########################################
    # Method to analyze HTML <img> tag, collect errors, and if there are any raise ImgWarnings with this errors
    #   img_analyze("<img title="title" src="src" alt="alt">") #=> don't raise exception
    #   img_analyze("<img title="title" src="">") #=> raise ImgWarnings([:src_empty, :alt_undeclared])
    def self.img_analyze(node)
      errors = []
      # Add attributes you want to check here
      ["title", "alt", "src"].each do |attribute|
        # attribute check is in tag_warning.rb
        attribute_check(errors, attribute, node)
      end
      raise Ca::Exceptions::ImgWarnings.new(errors) unless errors.empty?
    end
  end
end