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

  def self.play(args)
    setup_game(args.first)
    puts @player.location.description

    while command = gets().strip.split(" ")
      @player.check_actions(command)
      puts @player.location.description
    end
  end

  private

  def self.setup_game(story_name)
    setup_db(story_name)
    build_world(story_name)
    setup_player
  end

  def self.build_world(story_name)
    setup_db(story_name)
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
      @db.get_exits(room.name) do |exit|
        exit.select do |key, value|
          room.add_exit(key.to_sym, rooms[value]) if value
        end
      end
    end
  end

  def self.setup_player
    @player = Player.new(@rooms["living_room"])
    @player.add_action(WalkAction.new)
  end
end
