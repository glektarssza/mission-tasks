script.on_event("mission-tasks-main-frame-custom-input", function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  MainFrame.draw(player)
  TaskView.redraw(player)
end)

script.on_event("mission-tasks-input-close-all", function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  Gui.destroy_all(player)
  event.allowed = false
end)
