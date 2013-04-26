require_relative "actions"

module RadventureMachine
  class Player
    def initialize(starting_location)
      @items    = { }
      @actions  = [ ]
      @location = starting_location
    end
    attr_accessor :location
    include Actions
  end
end
