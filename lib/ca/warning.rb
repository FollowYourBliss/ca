# encoding: utf-8
module Ca
  # Class Ca::Warning
  class Warning
  ##########################################
  # Whitelist attributes
  ##########################################
    attr_accessor :forbidden

  ##########################################
  # Object methods
  ##########################################

    # Construct - get all three flags to initial values - falses
    def initialize
      @forbidden = false
    end

    # Set forbidden flag to true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>.forbidden_tags_warning #=> <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=false, @link=false>]>.forbidden_tags_warning #=> <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>
    def forbid
      @forbidden = true
    end

    # Return true if any of flags is set to true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>.any? #=> true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=false, @link=false>]>.any? #=> false
    def any?
      [@forbidden].any?
    end

  end
end