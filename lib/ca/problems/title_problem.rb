# encodint: utf-8
module Ca
  # Class Ca::TitleProblem
  class TitleProblem < Problem
  ##########################################
  # Object methods
  ##########################################
    # Class defined when meta keywords are empty
    def to_s
      "Title is empty"
    end

    # Short symbol represent this problem
    def to_sym
      :title
    end
  end
end