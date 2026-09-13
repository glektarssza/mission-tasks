script.on_event(defines.events.on_gui_checked_state_changed, function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  local element = event.element
  if not (element and element.valid) then return end

  if TaskViewSubtasks.handle_checked_state_changed_changed(player, element) then return end
end)
