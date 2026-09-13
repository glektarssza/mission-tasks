script.on_event(defines.events.on_player_selected_area, function(event)
  local player = game.get_player(event.player_index)
  if not player.valid then return end
  local player_state = State.ensure_player_state(player)
  local task_id = player_state.pending_location_edit
  if not task_id then return end

  local area = event.area
  local pos = {
    x = math.floor((area.left_top.x + area.right_bottom.x) / 2),
    y = math.floor((area.left_top.y + area.right_bottom.y) / 2)
  }

  Tasks.update_location(player, task_id, {
    position = pos,
    surface = player.surface.name
  })

  player_state.pending_location_edit = nil

  -- Update the tag on the map if necessary
  local task = Tasks.get_task(task_id)
  if not task then return end
  if task.show_on_map then
    if task.map_tag and task.map_tag.valid then task.map_tag.destroy() end
  end
  task.map_tag = player.force.add_chart_tag(player.surface, {
    position = pos,
    icon = task.icon or { type = "virtual", name = "map-pin-white" },
    text = task.title
  })
  task.show_on_map = true



  player.cursor_stack.clear()
  player.remove_item("task-location-selector")
  MainFrame.draw(player)

  Gui.refresh_tasks()
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
  local player = game.get_player(event.player_index)
  if not player or not player.valid then return end

  local player_state = State.ensure_player_state(player)
  if not player_state.pending_location_edit then return end

  local cursor = player.cursor_stack
  if not (cursor and cursor.valid_for_read and cursor.name == "task-location-selector") then
    -- Player canceled selection, clear item and state
    player.remove_item { name = "task-location-selector", count = 1 }
    player_state.pending_location_edit = nil
  end
end)
