# encoding: utf-8
module Ca
  module Exeptions
    class AContentEmpty < Exception

      def initialize(id)
        @position = position
      end

      def class
        "a_content_empty"
      end

    end
  end
end