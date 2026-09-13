script.on_event(defines.events.on_chart_tag_modified, function(event)
  if not event.player_index then return end
  local player = game.get_player(event.player_index)
  if not player.valid then return end

  local tag = event.tag
  if not tag.valid then return end

  for _, task in pairs(storage.tasks) do
    if task.map_tag and task.map_tag == tag then
      if task.location then
        Tasks.update_location(player, task.id, {
          position = tag.position,
          surface = tag.surface.name
        })
        Tasks.update_title(player, task.id, tag.text)
      end
      break
    end
  end
end)

script.on_event(defines.events.on_chart_tag_removed, function(event)
  if not event.player_index then return end
  local player = game.get_player(event.player_index)
  if not player.valid then return end

  local tag = event.tag
  if not tag.valid then return end

  for _, task in pairs(storage.tasks) do
    if task.map_tag and task.map_tag == tag then
      Tasks.update_show_on_map(player, task.id, false)
      break
    end
  end
end)
