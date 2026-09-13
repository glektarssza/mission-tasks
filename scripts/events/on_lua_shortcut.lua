script.on_event(defines.events.on_lua_shortcut, function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end

  local name = event.prototype_name

  if name == "mission-tasks-main-frame-shortcut" then
    MainFrame.draw(player)
    TaskView.redraw(player)
  end
end)
