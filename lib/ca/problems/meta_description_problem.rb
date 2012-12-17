# encodint: utf-8
module Ca
  # Class Ca::MetaDescriptionProblem
  class MetaDescriptionProblem < Problem
    # Class defined when meta description are empty
    def msg
      "<meta name='Description'> empty!"
    end
  end
end