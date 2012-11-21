# encoding: utf-8
module Ca
  # Class Ca::Warning
  class Warning
  ##########################################
  # Whitelist attributes
  ##########################################
    attr_accessor :img,
                  :forbidden,
                  :link

  ##########################################
  # Object methods
  ##########################################

    # Construct - get all three flags to initial values - falses
    def initialize
      @img = false
      @forbidden = false
      @link = false
    end

    # Set img flag to true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>.img_warning #=> <Ca::Warning:0x00000002d03318 @img=true, @forbidden=true, @link=false>]>
    #   <Ca::Warning:0x00000002d03318 @img=true, @forbidden=true, @link=false>]>.img_warning #=> <Ca::Warning:0x00000002d03318 @img=true, @forbidden=true, @link=false>]>
    def img_warning
      @img = true
    end

    # Set forbidden flag to true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>.forbidden_tags_warning #=> <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=false, @link=false>]>.forbidden_tags_warning #=> <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>
    def forbid
      @forbidden =   true
    end

    # Set link flag to true
    #   <Ca::Warning:0x00000002d03318 @img=true, @forbidden=false, @link=true>]>.link_warning #=> <Ca::Warning:0x00000002d03318 @img=true, @forbidden=false, @link=true>]>
    #   <Ca::Warning:0x00000002d03318 @img=true, @forbidden=false, @link=false>]>.link_warning #=> <Ca::Warning:0x00000002d03318 @img=true, @forbidden=false, @link=true>]>
    def link_warning
      @link = true
    end

    # Return true if any of flags is set to true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=true, @link=false>]>.any? #=> true
    #   <Ca::Warning:0x00000002d03318 @img=false, @forbidden=false, @link=false>]>.any? #=> false
    def any?
      [@forbidden, @img, @link].any?
    end

  end
end