TaskViewSubtasks = {}

--- Draws a list of subtasks in any GUI container.
--- @param player LuaPlayer
--- @param parent LuaGuiElement
--- @param task table
function TaskViewSubtasks.draw(player, parent, task)
  local section = parent.add{
    type = "frame",
    direction = "vertical",
    style = "deep_frame_in_shallow_frame_for_description",
  }

  section.add {
    type = "label",
    caption = {"gui-task-view-subtasks.subtasks"},
    style = "heading_2_label"
  }

  local input_flow = section.add{ type="flow", direction="horizontal" }

  local subtask_textfield = input_flow.add{
    type="textfield",
    name="mission-tasks-subtask-title",
    style = "stretchable_textfield",
    icon_selector = true,
  }
  subtask_textfield.style.horizontally_stretchable = true

  local selected_task_id = State.get_selected_task_id(player)
  if sub_id and selected_task_id then text.text = Tasks.get_subtask(selected_task_id, sub_id).title end
  local button = input_flow.add{
    type="sprite-button",
    name="mission-tasks-add-subtask-button",
    sprite = "mission-tasks-plus-white-icon",
    hovered_sprite  = "mission-tasks-plus-white-icon",
    clicked_sprite  = "mission-tasks-plus-white-icon",
    style = "slot_button",
    tooltip={"gui-task-view-subtasks.add-subtask-button-tooltip"},
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28

  local separator = section.add { type = "line" }
  separator.style.horizontally_stretchable = true
  separator.style.top_margin = 8
  separator.style.bottom_margin = 8

  local subtask_table = section.add{
    type="table",
    column_count = 3,
  }

  for _, subtask in ipairs(task.subtasks or {}) do
    local cell = subtask_table.add{
      type = "checkbox",
      state = subtask.done,
      name = "mission-tasks-subtask-checkbox-"..subtask.id,
      -- style = "slot_table",
    }
    cell.style.right_margin = 2

    local cell = subtask_table.add{
      type="label",
      caption=subtask.title,
      style="bold_label",
      name="mission-tasks-subtask-title-"..subtask.id,
      single_line = false,
    }
    cell.style.horizontally_stretchable = true

    local cell = subtask_table.add{
      type = "flow",
      direction = "horizontal"
    }

    local button = cell.add {
      type = "sprite-button",
      name = "mission-tasks-subtask-increase-priority-button-"..subtask.id,
      sprite = "mission-tasks-chevrons-up-white-icon",
      hovered_sprite  = "mission-tasks-chevrons-up-white-icon",
      clicked_sprite  = "mission-tasks-chevrons-up-white-icon",
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

    local button = cell.add {
      type = "sprite-button",
      name = "mission-tasks-subtask-decrease-priority-button-"..subtask.id,
      sprite = "mission-tasks-chevrons-down-white-icon",
      hovered_sprite  = "mission-tasks-chevrons-down-white-icon",
      clicked_sprite  = "mission-tasks-chevrons-down-white-icon",
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

    GuiHelper.add_vertical_divider(cell)

    local button = cell.add{
      type="sprite-button", style="slot_button",
      name="mission-tasks-edit-subtask-"..subtask.id,
      sprite="mission-tasks-pencil-white-icon",
      tooltip={"gui-task-view-subtasks.subtask-edit-tooltip"}
    }
    button.style.padding = 2
    button.style.height = 28
    button.style.width = 28

    local button = cell.add{
      type="sprite-button", style="red_slot_button",
      name="mission-tasks-delete-subtask-"..subtask.id,
      sprite="mission-tasks-trash-white-icon",
      tooltip={"gui-task-view-subtasks.subtask-delete-tooltip"}
    }
    button.style.padding = 2
    button.style.height = 28
    button.style.width = 28
  end
end

--- Draws a frame for editing a subtask
--- @param player LuaPlayer
--- @param subtask_id? number
--- @return LuaGuiElement
function TaskViewSubtasks.draw_edit_frame(player, task_id, subtask_id)
  Gui.close_all_secondaries_frames(player)

  local player_state = State.ensure_player_state(player)
  local frame = player.gui.screen.add{
    type="frame",
    direction="vertical",
    name="mission-tasks-subtask-frame",
  }
  frame.auto_center = true
  frame.style.width = 500

  local titlebar = GuiHelper.create_titlebar(frame, frame, { "gui-task-view-subtasks.subtask-edit-title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-subtask-frame")

  ------------------------------------------------
  -- CONTENT
  ------------------------------------------------

  local text = frame.add{
    type="textfield",
    name="mission-tasks-subtask-title",
    text="",
    style = "stretchable_textfield",
    icon_selector = true,
  }

  if subtask_id and task_id then
    local subtask = Tasks.get_subtask(task_id, subtask_id)
    if subtask and subtask.title then text.text = subtask.title end
    player_state.selected_subtask_id = subtask_id
  end

  ------------------------------------------------

  local bottom_frame_flow = GuiHelper.add_bottom_bar(frame, "mission-tasks-subtask-frame" )
  bottom_frame_flow.add{
    type="button",
    name="mission-tasks-confirm-edit-subtask",
    caption={"gui-task-view-subtasks.subtask-frame-confirm"},
    style="confirm_button",
  }



  return frame
end

--- Handles click events on dialog buttons
--- @param event LuaEvent
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function TaskViewSubtasks.handle_click(event, player, element, gui)
  local name = element.name

  if name == "mission-tasks-add-subtask-button" then
    local task_id = State.get_selected_task_id(player)
    local subtask_textfield = TaskView.get_subtask_textfield(player)

    if task_id and subtask_textfield and subtask_textfield.valid and subtask_textfield.text ~= "" then
      Tasks.add_subtask(player, task_id, subtask_textfield.text)

      local subtask_textfield = TaskView.get_subtask_textfield(player)
      if subtask_textfield and subtask_textfield.valid then subtask_textfield.text = "" end
    end
    return true

  -- Editar exist.
  elseif name:match("^mission%-tasks%-edit%-subtask%-(%d+)$") then
    local subtask_id = tonumber(name:match("%d+$"))
    local task_id = State.get_selected_task_id(player)
    TaskViewSubtasks.draw_edit_frame(player, task_id, subtask_id)
    return true

  -- Remover
  elseif name:match("^mission%-tasks%-delete%-subtask%-(%d+)$") then
    local subtask_id = tonumber(name:match("%d+$"))
    local task_id = State.get_selected_task_id(player)
    Tasks.remove_subtask(player, task_id, subtask_id)
    return true
  elseif name:match("^mission%-tasks%-subtask%-increase%-priority%-button%-(%d+)$") then
    local subtask_id = tonumber(name:match("%d+$"))
    local task_id = State.get_selected_task_id(player)

    if task_id and subtask_id then
      if event.shift then
        Tasks.move_subtask_priority(player, task_id, subtask_id, "top")
      else
        Tasks.move_subtask_priority(player, task_id, subtask_id, "up")
      end
    end
    return true
  elseif name:match("^mission%-tasks%-subtask%-decrease%-priority%-button%-(%d+)$") then
    local subtask_id = tonumber(name:match("%d+$"))
    local task_id = State.get_selected_task_id(player)
    if task_id and subtask_id then
      if event.shift then
        Tasks.move_subtask_priority(player, task_id, subtask_id, "bottom")
      else
        Tasks.move_subtask_priority(player, task_id, subtask_id, "down")
      end
    end
    return true
  elseif name == "mission-tasks-confirm-edit-subtask" then
    local subtask_id = gui.selected_subtask_id
    local task_id = State.get_selected_task_id(player)

    local subtask_frame = player.gui.screen["mission-tasks-subtask-frame"]

    local subtask_textfield = subtask_frame and subtask_frame["mission-tasks-subtask-title"]
    if subtask_textfield and subtask_textfield.valid and subtask_textfield.text ~= "" then
      Tasks.edit_subtask(player, task_id, subtask_id, subtask_textfield.text)
    end

    if subtask_frame and subtask_frame.valid then subtask_frame.destroy() end
    return true
  elseif name == "mission-tasks-subtask-frame-close-button" or name == "mission-tasks-subtask-frame-close-top-button" then
    local subtask_frame = player.gui.screen["mission-tasks-subtask-frame"]
    if subtask_frame and subtask_frame.valid then subtask_frame.destroy() end
    return true
  end

  return false
end

--- Handles checked state changes
--- @param player LuaPlayer
--- @param element LuaGuiElement
function TaskViewSubtasks.handle_checked_state_changed_changed(player, element)
  local name = element.name

  if name:match("^mission%-tasks%-subtask%-checkbox%-(%d+)$") then
    local sub_id = tonumber(name:match("%d+$"))
    local task_id = State.get_selected_task_id(player)
    Tasks.toggle_subtask(player, task_id, sub_id, element.state)
    return true
  end

  return false
end
