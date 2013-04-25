require_relative 'radventure_machine/db_manager'
require_relative 'radventure_machine/noun'
require_relative 'radventure_machine/room'

module RadventureMachine
  def self.add_room(args)
    story_name = args[0]
    db = DBManager.new(story_name)
    db.add_room(args[1], args[2], args[3..-1])
  end

  def self.build_world(story_name)
    db = DBManager.new(story_name)
    db.get_rooms do |room|
      build_room(room)
    end
    setup_exits(self.instance_variables)
  end

  private

  def self.build_room(room)
    instance_variable_set("@#{room["name"]}",
                          Room.new(room["name"],
                                   room["description"]))
  end

  def self.setup_exits(rooms)
    rooms.each do |room|
      p room.name
      # @db.get_exits(room.name).each do |exits|
      #   p exits
    end
  end

  # def self.play(args)
  #   story_name = args[0]
  #   build_rooms(story_name)
  # end
end
