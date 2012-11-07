# encoding: utf-8
require "ca/version"
require "features"

module Ca
  class Description
    attr_reader :hash
    def initialize(input)
      @hash = {}
      fill_hash(input)
    end

  private
    def fill_hash(input)
      input.each do |key, value|
        @hash.store(key, Ca::Features.new(key, value, input))
      end
    end
  end

end