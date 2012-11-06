# encoding: utf-8

class String

  def html_remove
    gsub(/<\/?[^>]+>/, '')
  end

end