# Ca - Copywriter Analyser

Gem than analyse HTML text structure according to SEO methods. 
It split text to phrases and fetch tags of each occurrence. Allowing to confer them poits counted by tags strength list.
Also search problems with HTML tags like empty href in <a> or empty meta keywords/description. 
Collect information about phrases like: occurance, count, length, value of tags strength analyse etc.
	
 
## Installation

Add this line to your application's Gemfile:

    gem 'ca'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ca

## Usage

To run analyse use

    analyse = Ca::Analyse.new("<html>HTML text</html>")

it create Ca::Analyse object with description field that contain .result method

    analyse.description.result

return Hash contain keys:
        problems - Array of main problems with website (elements are Ca::Problems)  
        text - Nokogiri::HTML::Document structure of analysed site, without some tags (script, link, style)
        best_phrases - best phrases as Hash :"phrase" => Ca::Features
        nr_of_chars
        nr_of_words
        nr_of_nodes - number of Nokogiri nodes
        score - final score for website
        plagiarism - logic value of Similar Test (true - page is simmilar with another site) 
        html - HTML text
        tags_problem - flag that is set when is there any problem with tags

Also u can run `rake` in comand line and follow instructions

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
