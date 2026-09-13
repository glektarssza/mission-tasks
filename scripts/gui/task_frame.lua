TaskFrame = {}

--- Draws the new/edit task frame.
--- @param player LuaPlayer
--- @param mode 'new' | 'edit' | 'copy'
--- @param task? table
--- @param index? integer
function TaskFrame.draw(player, mode, task, index)
  Gui.close_all_secondaries_frames(player)

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-task-frame",
    direction = "vertical",
  }
  frame.auto_center = true

  local titlebar = GuiHelper.create_titlebar(frame, frame, mode == 'new' and { "gui-task-frame.new-task-title" } or mode == 'edit' and { "gui-task-frame.edit-task-title" } or mode == 'copy' and { "gui-task-frame.copy-task-title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-task-frame")

  ------------------------------------------------
  -- CONTENT
  ------------------------------------------------

  local inner_frame = frame.add {
    type = "frame",
    direction = "vertical",
    style = "inside_shallow_frame_with_padding",
  }
  inner_frame.style.horizontally_stretchable = true

  -- Icon
  inner_frame.add { type = "label", caption = {"gui-task-frame.icon-label"}, style = "label" }
  inner_frame.add {
    type = "choose-elem-button",
    name = "mission-tasks-task-frame-icon-selector",
    elem_type = "signal",
    signal = { type = "virtual", name = "map-pin-white" },
    tooltip = {"gui-task-view-location.icon-tooltip"},
  }

  -- Title
  inner_frame.add {
    type = "label",
    caption = { "gui-task-frame.title-label" }
  }

  local title_textfield = inner_frame.add {
    type = "textfield",
    name = "mission-tasks-task-frame-title-textfield",
    text = task and task.title or "",
    placeholder_text = { "task-frame.title-placeholder" },
    icon_selector = true,
    style_mods = { width = 250 }
  }
  title_textfield.style.width = 600


  -- Description
  inner_frame.add {
    type = "label",
    caption = { "gui-task-frame.description-label" }
  }

  local description_textbox = inner_frame.add {
    type = "text-box",
    name = "mission-tasks-task-frame-description-textbox",
    text = task and task.desc or "",
    placeholder_text = { "task-frame.description-placeholder" },
    word_wrap = true,
    style_mods = { width = 250, height = 100 }
  }
  description_textbox.style.height = 100
  description_textbox.style.width = 600

  -- Status
  inner_frame.add {
    type = "label",
    caption = { "gui-task-frame.status-label" }
  }

  inner_frame.add {
    type = "drop-down",
    name = "mission-tasks-task-frame-status-dropdown",
    items = StatusEnum.external_values,
    selected_index = task and StatusEnum.index_from_value(task.status) or 1,
    style_mods = { width = 250 }
  }

  ------------------------------------------------

  local bottom_frame_flow = GuiHelper.add_bottom_bar(frame, "mission-tasks-task-frame")

  local action_name = mode == 'new' and 'mission-tasks-task-frame-add-task-button'
    or mode == 'edit' and ('mission-tasks-task-frame-save-task-button')
    or mode == 'copy' and 'mission-tasks-task-frame-copy-task-button'

  bottom_frame_flow.add {
    type = "button",
    name = action_name,
    style = "confirm_button",
    caption = mode == 'new' and { "gui-task-frame.add-task-button" } or mode == 'edit' and { "gui-task-frame.save-task-button" } or mode == 'copy' and { "gui-task-frame.add-task-button" }
  }
end

--- Destroy the task frame.
--- @param player LuaPlayer
function TaskFrame.destroy(player)
  local frame = player.gui.screen["mission-tasks-task-frame"]
  if frame then frame.destroy() end
end

function TaskFrame.get_task_icon(player)
  local frame = player.gui.screen["mission-tasks-task-frame"]
  local element = Gui.find_element(frame, "mission-tasks-task-frame-icon-selector")
  if not (element and element.valid and element.elem_value) then return end
  return element.elem_value

end

--- Gets the title of the task.
--- @param player LuaPlayer
--- @return string
function TaskFrame.get_task_title(player)
  local frame = player.gui.screen["mission-tasks-task-frame"]
  local element = Gui.find_element(frame, "mission-tasks-task-frame-title-textfield")
  if not (element and element.valid and element.text) then return end
  return element.text or ""
end

--- Gets the description of the task.
--- @param player LuaPlayer
--- @return string
function TaskFrame.get_task_description(player)
  local frame = player.gui.screen["mission-tasks-task-frame"]
  local element = Gui.find_element(frame, "mission-tasks-task-frame-description-textbox")
  if not (element and element.valid and element.text) then return end
  return element.text or ""
end

--- Gets the status of the task.
--- @param player LuaPlayer
--- @return string
function TaskFrame.get_task_status(player)
  local frame = player.gui.screen["mission-tasks-task-frame"]
  local element = Gui.find_element(frame, "mission-tasks-task-frame-status-dropdown")
  if not (element and element.valid and element.selected_index) then return end
  return StatusEnum.value_from_index(element.selected_index) or ""
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
function TaskFrame.handle_click(player, element)
  local name = element.name

  if name == "mission-tasks-task-frame-add-task-button" then -- Add task
    local icon    = TaskFrame.get_task_icon(player)
    local title   = TaskFrame.get_task_title(player)
    local desc    = TaskFrame.get_task_description(player)
    local status  = TaskFrame.get_task_status(player)

    if not title or title == "" then
      player.print({ "gui-task-frame.title-empty-warn" })
      return
    end

    local new_task_id = Tasks.add_task(player, {
      title  = title,
      desc   = desc,
      status = status,
      icon = icon,
    })
    TaskFrame.destroy(player)

    State.update_selected_task_id(player, new_task_id)
    TaskList.redraw(player)
    return true
  elseif name == "mission-tasks-task-frame-copy-task-button" then -- Add task
    local selected_task_id = State.get_selected_task_id(player)

    local icon    = TaskFrame.get_task_icon(player)
    local title   = TaskFrame.get_task_title(player)
    local desc    = TaskFrame.get_task_description(player)
    local status  = TaskFrame.get_task_status(player)

    local subtasks = nil

    if selected_task_id then
      local original_task = Tasks.get_task(selected_task_id)
      icon = original_task.icon
      subtasks = original_task.subtasks
    end

    local new_task_id = Tasks.add_task(player, {
      title  = title,
      desc   = desc,
      status = status,
      icon = icon,
      subtasks = subtasks,
    })
    TaskFrame.destroy(player)

    State.update_selected_task_id(player, new_task_id)
    TaskList.redraw(player)
    return true
  elseif name == "mission-tasks-task-frame-save-task-button" then -- Save task
    local icon    = TaskFrame.get_task_icon(player)
    local title   = TaskFrame.get_task_title(player)
    local desc    = TaskFrame.get_task_description(player)
    local status  = TaskFrame.get_task_status(player)

    if not title or title == "" then
      player.print({ "gui-task-frame.title-empty-warn" })
      return
    end

    local selected_task_id = State.get_selected_task_id(player)
    if not selected_task_id then return end

    Tasks.update_task(player, selected_task_id, {
      title  = title,
      desc   = desc,
      status = status,
      icon = icon,
    })

    TaskFrame.destroy(player)
    return true
  elseif name == "mission-tasks-task-frame-close-button" or name == "mission-tasks-task-frame-close-top-button" then -- Close task frame
    TaskFrame.destroy(player)
    return true
  end

  return false
end
