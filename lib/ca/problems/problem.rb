# encoding: utf-8
module Ca
  # Class Ca::Problem
  class Problem
  ##########################################
  # Includes modules
  ##########################################
    include AbstractInterface
    # Interface methods
    needs_implementation  :to_s,
                          :to_sym
  end
end