script.on_event(defines.events.on_gui_value_changed, function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  local element = event.element
  if not (element and element.valid) then return end

  if SettingsFrame.handle_gui_value_changed(player, element) then return end
end)
