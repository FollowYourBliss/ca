# encodint: utf-8
module Ca
  # Class Ca::MetaDescriptionProblem
  class MetaKeywordsProblem < Problem
  ##########################################
  # Object methods
  ##########################################
    # Class defined when meta keywords are empty
    def to_s
      "<meta name='Keywords'> empty!"
    end

    # Short symbol represent this problem
    def to_sym
      :keywords
    end
  end
end