# encoding: utf-8

class String
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
    split.size
  end

end