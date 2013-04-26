module Actions
  def add_action(action)
    action.parent = self
    @actions << action
  end

  def check_actions(command)
    @actions.each do |action|
      action.process(command) if action.handle?(command)
    end
  end
end
