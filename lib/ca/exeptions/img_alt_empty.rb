# encoding: utf-8
module Ca
  module Exeptions
    class ImgAltEmpty < Exception

      def initialize(id)
        @position = position
      end

      def class
        "img_alt_empty"
      end

    end
  end
end