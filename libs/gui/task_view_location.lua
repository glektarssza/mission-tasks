TaskViewLocation = {}

function TaskViewLocation.draw(parent, task)
  -- Location
  parent.add { type = "label", caption = {"" , {"gui-task-view-location.edit-location-label"} , ": "}, style = "caption_label" }
  local location_flow = parent.add { type = "flow", direction = "horizontal" }

  local button = location_flow.add {
    type = "sprite-button",
    name = "mission-tasks-edit-location-button",
    sprite = "mission-tasks-map-white-icon",
    hovered_sprite  = "mission-tasks-map-white-icon",
    clicked_sprite  = "mission-tasks-map-white-icon",
    tooltip = {"gui-task-view-location.edit-location-button-tooltip"},
    style = "slot_button",
  }
  button.style.padding = 2
  button.style.height = 32
  button.style.width = 32

  local button = location_flow.add {
    type = "sprite-button",
    name = "mission-tasks-remove-location-button",
    sprite = "mission-tasks-rollback-white-icon",
    tooltip = {"gui-task-view-location.remove-location-button-tooltip"},
    style = "red_slot_button",
  }
  button.style.padding = 2
  button.style.height = 32
  button.style.width = 32

  -- Show location
  parent.add { type = "label", caption = {"" , {"gui-task-view-location.open-location-label"} , ": "}, style = "caption_label" }
  parent.add {
    type = "button",
    name = "mission-tasks-open-location-button",
    caption = string.format("%s [%d, %d]", SpriteHelper.location_to_rich_text(task.location), task.location.position.x, task.location.position.y),
    tooltip = {"gui-task-view-location.open-location-tooltip"},
  }

  -- Checkbox
  parent.add { type = "label", caption = {"gui-task-view-location.show-on-map-label"}, style = "caption_label" }
  parent.add {
    type = "checkbox",
    name = "mission-tasks-show-on-map",
    state = task.show_on_map or false,
    tooltip = {"gui-task-view-location.show-on-map-tooltip"},
  }
end
