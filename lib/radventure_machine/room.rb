require_relative "noun"

module RadventureMachine
  class Room < Noun
    def initialize(name, description)
      super(name, description)
      @exits = { }
    end
    attr_reader :name, :description, :exits

    def add_exit(direction, room)
      @exits[direction] = room
    end

  end
end
