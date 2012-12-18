
# encoding: utf-8
module Ca
  module Exceptions
    # Class Ca::Text::TooLongExeption
    class TooLongText < Exception
      # Exeption that raise when while analyse NodeCounter is > Ca::Config.instance.max_nr_of_nodes
    end
  end
end