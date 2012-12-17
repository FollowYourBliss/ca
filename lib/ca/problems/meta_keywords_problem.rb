# encodint: utf-8
module Ca
  # Class Ca::MetaDescriptionProblem
  class MetaKeywordsProblem < Problem
    # Class defined when meta keywords are empty
    def msg
      "<meta name='Keywords'> empty!"
    end
  end
end