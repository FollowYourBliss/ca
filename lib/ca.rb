# encoding: utf-8
require "rubygems"
require "nokogiri"
require "singleton"
require "string"
require "html_reader"
require "net/http"
require "net/https"
require "open-uri"
require "mechanize"
require "enumerable"
require "csv"
require 'RMagick'
require "gruff"
require "abstract_interface"

require "ca/analyse"
require "ca/config"
require "ca/description"
require "ca/features"
require "ca/node_counter"
require "ca/similar_test"
require "ca/text_analitics"
require "ca/version"
require "ca/warning"


require "ca/exceptions/img_warnings"
require "ca/exceptions/link_warnings"
require "ca/exceptions/tag_warnings"
require "ca/exceptions/title_warnings"
require "ca/exceptions/incomplete_tags"

require "ca/problems/problem"
require "ca/problems/h_problem"
require "ca/problems/meta_description_problem"
require "ca/problems/meta_keywords_problem"


require "nokogiri/HTML/node_specyfication"
require "nokogiri/HTML/document"
require "nokogiri/XML/node"
