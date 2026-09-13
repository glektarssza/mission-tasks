TaskViewHeader = {}

function TaskViewHeader.draw(parent, task)
  local header = parent.add { type = "frame", direction = "horizontal", style = "inside_deep_frame" }
  header.style.horizontally_stretchable = true
  header.style.padding = 8

  local table = header.add { type = "table", column_count = 2 }
  table.add { type = "sprite", sprite = SpriteHelper.icon_to_sprite(task.icon), resize_to_sprite = true }
  local title = table.add { type = "label", caption = (task.title or "-"), style = "heading_2_label" }
  title.style.maximal_width = 450

  local spacer = header.add { type = "empty-widget" }
  spacer.style.horizontally_stretchable = true

  local header_button_flow = header.add { type = "flow", direction = "horizontal" }
  header_button_flow.style.horizontal_align = "right"

  local button = header_button_flow.add {
    type = "sprite-button",
    name = "mission-tasks-increase-priority-button",
    sprite = "mission-tasks-chevrons-up-white-icon",
    hovered_sprite = "mission-tasks-chevrons-up-white-icon",
    clicked_sprite = "mission-tasks-chevrons-up-white-icon",
    style = "slot_button",
    tooltip = {
      "",
      { "gui-task-view.increase-priority-button-tooltip" },
      "\n",
      "[color=#808080] ",
      { "gui-task-view.increase-priority-button-tooltip-description", "[color=#73b6d3][font=default-bold]Shift[/font][/color]" },
      "[/color]",
    },
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28


  local button = header_button_flow.add {
    type = "sprite-button",
    name = "mission-tasks-decrease-priority-button",
    sprite = "mission-tasks-chevrons-down-white-icon",
    hovered_sprite = "mission-tasks-chevrons-down-white-icon",
    clicked_sprite = "mission-tasks-chevrons-down-white-icon",
    style = "slot_button",
    tooltip = {
      "",
      { "gui-task-view.decrease-priority-button-tooltip" },
      "\n",
      "[color=#808080] ",
      { "gui-task-view.decrease-priority-button-tooltip-description", "[color=#73b6d3][font=default-bold]Shift[/font][/color]" },
      "[/color]",
    },
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28

  GuiHelper.add_vertical_divider(header_button_flow)

  local button = header_button_flow.add {
    type = "sprite-button",
    name = "mission-tasks-duplicate-task-button",
    sprite = "mission-tasks-copy-white-icon",
    hovered_sprite  = "mission-tasks-copy-white-icon",
    style = "slot_button",
    tooltip = { "gui-task-view.duplicate-task-button-tooltip" },
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28

  local button = header_button_flow.add {
    type = "sprite-button",
    name = "mission-tasks-edit-task-button",
    sprite = "mission-tasks-pencil-white-icon",
    hovered_sprite = "mission-tasks-pencil-white-icon",
    style = "slot_button",
    tooltip = { "gui-task-view.edit-task-button-tooltip" }
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28

  local button = header_button_flow.add {
    type = "sprite-button",
    name = "mission-tasks-delete-task-button",
    sprite = "mission-tasks-trash-white-icon",
    style = "red_slot_button",
    tooltip = { "gui-task-view.remove-task-button-tooltip" }
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28
end
