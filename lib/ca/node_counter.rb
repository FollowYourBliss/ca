# encoding: utf-8
module Ca
  # Class Ca::NodeCounter
  # Singleton to count nodes
#################################################
############################### SINGLETON   CLASS
#################################################
  class NodeCounter
  ##########################################
  # Includes modules
  ##########################################
    include Singleton
  ##########################################
  # Getters and setters
  ##########################################
    attr_reader :value
  ##########################################
  # Object methods
  ##########################################
    # Construct, initialize counter value with 0
    def initialize
      @value = 0
    end

    # Increments counter
    def increment
      raise Ca::Exceptions::TooLongText if @value > Ca::Config.instance.max_nr_of_nodes
      @value += 1
    end


    # Reset counter
    def reset
      @value = 0
    end
  end
end