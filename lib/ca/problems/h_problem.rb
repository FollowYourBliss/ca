# encoding: utf-8
module Ca
  # Class Ca::HProblem
  class HProblem < Problem
    # Return information that h1 can be only one in whole document
    def msg
      "Problem with h1 - it can be only one"
    end
  end
end