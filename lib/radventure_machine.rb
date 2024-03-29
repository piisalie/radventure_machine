require_relative 'radventure_machine/db_manager'

require_relative 'radventure_machine/actions'
require_relative 'radventure_machine/walk_action'

require_relative 'radventure_machine/noun'
require_relative 'radventure_machine/room'
require_relative 'radventure_machine/player'

module RadventureMachine
  def self.add_room(args)
    story_name = args[0]
    setup_db(story_name)
    @db.add_room(args[1], args[2], args[3..-1])
  end

  def self.play(story_name)
    setup_game(story_name)
    puts @player.location.description

    while command = $stdin.gets().strip.split(" ")
      @player.check_actions(command)
      puts @player.location.description
    end
  end

  private

  def self.setup_game(story_name)
    setup_db(story_name)
    build_world
    setup_player
  end

  def self.build_world
    @rooms = { }
    @db.get_rooms do |room|
      @rooms[room.name] = room
    end
    setup_exits(@rooms)
  end

  def self.setup_db(story_name)
    @db = DBManager.new(story_name)
  end

  def self.setup_exits(rooms)
    rooms.each do |name, room|
      lookup_exits(name).each do |direction, room_name|
        room.add_exit(direction.to_sym, rooms[room_name])
      end
    end
  end

  def self.lookup_exits(room)
    @db.get_exits(room).delete_if {|direction, room_name|
      room_name.nil? }
  end

  def self.setup_player
    @player = Player.new(@rooms["living_room"])
    @player.add_action(WalkAction.new)
  end
end
