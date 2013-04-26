module RadventureMachine
  class WalkAction
    attr_writer :parent

    def handle?(command)
      return true if command[0] == "walk"
    end

    def process(command)
      fail "WalkAction needs a parent." unless @parent
      if @parent.location.exits[command[1].to_sym]
        @parent.location = @parent.location.exits[command[1].to_sym]
      else
        puts "There isn't an exit in that direction."
      end
    end
  end
end

  
