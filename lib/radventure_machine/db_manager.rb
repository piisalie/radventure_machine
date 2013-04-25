require "pg"
require_relative 'room.rb'

module RadventureMachine
  class DBManager
    def initialize(story_name)
      @db = PG.connect(dbname: "#{story_name}")
    end

    def add_room(name, description, exits)
      door = parse_exits(exits)
      @db.exec("INSERT INTO rooms (name, description, east, west, up, down) VALUES ($1, $2, $3, $4, $5, $6);",
               [name, description,
                door[:east], door[:west],
                door[:up], door[:down]])
    end

    def get_rooms
      @db.exec("SELECT name, description FROM rooms;").each do |room|
        yield room
      end
    end

    def get_exits(room)
      @db.exec("SELECT east, west, up, down FROM rooms
                WHERE name = $1;", [room]).each do |exits|
        yield exits
      end
    end

    private

    def parse_exits(exits)
      doors = { }
      exits.each do |exit|
        direction = exit.split(":").first.to_sym
        room      = exit.split(":").last
        doors[direction] = room
      end
      return doors
    end
  end
end
