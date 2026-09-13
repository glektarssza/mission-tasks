script.on_event(defines.events.on_gui_click, function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  local player_state = State.ensure_player_state(player)
  local element = event.element
  if not (element and element.valid) then return end

  if SettingsFrame.handle_click(player, element, player_state) then return end
  if MainFrame.handle_click(player, element, player_state) then return end
  if TaskView.handle_click(event, player, element, player_state) then return end
  if TaskViewSubtasks.handle_click(event, player, element, player_state) then return end
  if TaskFrame.handle_click(player, element, player_state) then return end
  if ConfirmDialog.handle_click(player, element) then return end
  if ImportFrame.handle_click(player, element) then return end
  if ExportFrame.handle_click(player, element) then return end
  if InfoFrame.handle_click(player, element) then return end
end)
