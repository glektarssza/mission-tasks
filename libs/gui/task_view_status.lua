TaskViewStatus = {}

--- Creates a task status selection field
--- @param parent LuaGuiElement
--- @param task table
--- @return table<{ status_dropdown: LuaGuiElement }>
function TaskViewStatus.draw(parent, task)
  parent.add{
    type = "label",
    caption = { "", { "gui-task-view-status.status-label" }, ": " },
    style = "caption_label"
  }

  local dropdown = parent.add{
    type = "drop-down",
    name = "mission-tasks-status-dropdown",
    items = StatusEnum.external_values,
    selected_index = StatusEnum.index_from_value(task.status),
  }

  return {
    status_dropdown = dropdown,
  }
end
