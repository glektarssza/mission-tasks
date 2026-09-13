TaskViewAssignee = {}

function TaskViewAssignee.draw(parent, task)
  parent.add { type = "label", caption = {"", {"gui-task-view-assignee.assignee-label"}, ": "}, style = "caption_label"}

  local dropdown = parent.add {
    type = "drop-down",
    items = { {"gui-task-view-assignee.unnassigned"}, {"gui-task-view-assignee.everyone"} },
    selected_index = 1,
    name = "mission-tasks-assign-dropdown",
  }


  local index_to_select = 1

  for _, player in pairs(game.players) do
    if player.connected then
      dropdown.add_item(player.name)
      if task.assigned_id and player.index == task.assigned_id then
        index_to_select = #dropdown.items
      end
    end
  end

  if task.assigned_id == -1 then
    index_to_select = 2 -- everyone
  end

  dropdown.selected_index = index_to_select
end
