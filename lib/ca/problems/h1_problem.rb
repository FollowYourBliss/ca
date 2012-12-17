# encoding: utf-8
module Ca
  # Class Ca::H1Problem
  class H1Problem < Problem
  ##########################################
  # Object methods
  ##########################################
    # Return information that h1 can be only one in whole document
    def to_s
      "Problem with h1 - it can be only one"
    end

    # Short symbol of problem
    def to_sym
      :h1
    end
  end
end