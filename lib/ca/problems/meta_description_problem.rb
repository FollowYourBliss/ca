# encodint: utf-8
module Ca
  # Class Ca::MetaDescriptionProblem
  class MetaDescriptionProblem < Problem
  ##########################################
  # Object methods
  ##########################################
    # Class defined when meta description are empty
    def to_s
      "<meta name='Description'> empty!"
    end

    # Shrot symbol represent problem
    def to_sym
      :description
    end

  end
end