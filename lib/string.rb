# encoding: utf-8
class String
  ##########################################
  # Object methods
  ##########################################

  # Add to String +additional+ String Object if not include in it
  #   "Alice have got cat".add_if_not_include("cat") #=> "Alice have got cat"
  #   "Alice have got cat".add_if_not_include(" and dog") #=> "Alice have got cat and dog"
  def add_if_not_include(additional)
    return self + additional unless self.include? additional
    return self
  end

  # Return String without HTML tags
  #   "<b>sample</b>".html_remove #=> "sample"
  #   "<a href='www.google.com'>Link</a>" #=> "Link"
  def html_remove
    gsub(/<\/?[^>]+>/, '')
  end

  # Return String with additional space characters if they don't exist
  #   "sample".spaces_suround #=> " sample "
  #   "test ".spaces_suround #=> " test "
  def spaces_suround
    string = self
    unless [-1] == " "
      string = string + " "
    end
    unless [0] == " "
      string = " " + string
    end
    string
  end

  # Return number of words in Simple string
  #   "koko piko".nr_of_words #=> 2
  #   "Alice have got cat." #=> 4
  def nr_of_words
    html_remove.split.size
  end

  # Change encoding from any to utf-8, must be declarated in argument
  def to_utf8(encoding = "utf-8")
    force_encoding(encoding).encode("utf-8", replace: nil)
  end





  # Remove dots and other unnecessary chars, keep only necessary to analyze
  def without_garbage
    reg = Regexp.new /[#{String.characters.join}]+/
    p self.scan(reg).join("").gsub("\n", " ").gsub("|", " ")
    self.scan(reg).join("").gsub("\n", " ").gsub("|", " ").gsub("-", " ")
  end

  ##########################################
  # Class methods
  ##########################################
  # Return array of all latters from alphabets
  def self.characters
    alphabet = ('a'..'z').to_a + ('A'..'Z').to_a
    digits = ('0'..'9').to_a
    polish = %w(ą Ą ć Ć ż Ż ź Ź ń Ń ś Ś ł Ł ó Ó ę Ę)
    alphabet + digits + polish + [" ", "\n"]
  end

end