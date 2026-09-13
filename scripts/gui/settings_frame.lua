SettingsFrame = {}

-----------------------------------------------------------------------------
-- Settings Groups
-----------------------------------------------------------------------------

local function draw_task_hud_settings(parent, player)
  local config = Settings.get(player.index)

  local group = parent.add {
    type = "flow",
    direction = "vertical",
  }
  group.add { type = "label", caption = { "gui-settings.visualization-group-caption" }, style = "heading_2_label" }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-tasks-hud",
    state   = config.show_tasks_hud,
    caption = { "gui-settings.show-tasks-hud" }
  }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-subtasks-hud",
    state   = config.show_subtasks_hud,
    caption = { "gui-settings.show-subtasks-hud" },
    enabled = config.show_tasks_hud
  }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-completed-subtasks-hud",
    state   = config.show_completed_subtasks_hud,
    caption = { "gui-settings.show-completed-subtasks-hud" },
    enabled = config.show_tasks_hud and config.show_subtasks_hud
  }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-todo-tasks-hud",
    state   = config.show_todo_tasks_hud,
    caption = { "gui-settings.show-todo-tasks-hud" },
    enabled = config.show_tasks_hud
  }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-doing-tasks-hud",
    state   = config.show_doing_tasks_hud,
    caption = { "gui-settings.show-doing-tasks-hud" },
    enabled = config.show_tasks_hud
  }

  group.add {
    type    = "checkbox",
    name    = "mission-tasks-setting-show-done-tasks-hud",
    state   = config.show_done_tasks_hud,
    caption = { "gui-settings.show-done-tasks-hud" },
    enabled = config.show_tasks_hud
  }

  local flow = group.add { type = "flow", direction = "horizontal" }
  flow.add { type = "label", direction = "horizontal", caption = { "gui-settings.font-size-label" } }
  flow.add { type = "empty-widget" }.style.horizontally_stretchable = true
  local dropdown = flow.add {
    type = "drop-down",
    name = "mission-tasks-setting-font-size",
    items = FontSizeEnum.external_values,
    selected_index = FontSizeEnum.index_from_value(config.font_size),
  }
  dropdown.selected_index = (config.font_size == FontSizeEnum.SMALL) and 1
      or (config.font_size == FontSizeEnum.MEDIUM) and 2
      or 3

  local flow = group.add { type = "flow", direction = "horizontal" }
  flow.style.vertical_align = "center"
  flow.add {
    type = "label",
    direction = "horizontal",
    caption = { "gui-settings.hud-opacity-slider-label" }
  }.style.right_margin = 4

  local opacity_slider = flow.add {
    type = "slider",
    name = "mission-tasks-setting-hud-opacity",
    value = config.hud_opacity,
    minimum_value = 0,
    maximum_value = 100,
    value_step = 10,
    style = "notched_slider"
  }
  opacity_slider.style.right_margin = 4
  opacity_slider.style.horizontally_stretchable = true

  flow.add {
    type = "textfield",
    name = "mission-tasks-setting-hud-opacity-textfield",
    text = config.hud_opacity,
    style = "slider_value_textfield",
    enabled = false
  }
end

local function draw_import_export_settings(parent)
  local group = parent.add {
    type = "flow",
    direction = "vertical",
  }
  group.add { type = "label", caption = { "gui-settings.export-import-group-caption" }, style = "heading_2_label" }

  local table = group.add { type = "table", column_count = 2 }

  local label = table.add { type = "label", direction = "horizontal", caption = { "gui-settings.export-button-label" } }
  label.style.horizontally_stretchable = true

  local button = table.add {
    type = "sprite-button",
    name = "mission-tasks-settings-export",
    sprite = "mission-tasks-upload-white-icon",
    hovered_sprite  = "mission-tasks-upload-white-icon",
    clicked_sprite  = "mission-tasks-upload-white-icon",
    tooltip = { "gui-settings.export-button-tooltip" },
    style = "slot_button"
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28

  local label = table.add { type = "label", direction = "horizontal", caption = { "gui-settings.import-button-label" } }
  label.style.horizontally_stretchable = true

  local button = table.add {
    type = "sprite-button",
    name = "mission-tasks-settings-import",
    sprite = "mission-tasks-download-white-icon",
    hovered_sprite  = "mission-tasks-download-white-icon",
    clicked_sprite  = "mission-tasks-download-white-icon",
    tooltip = { "gui-settings.import-button-tooltip" },
    style = "slot_button"
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28
end

local function draw_tasks_settings(parent)
  local group = parent.add {
    type = "flow",
    direction = "vertical",
  }
  group.add { type = "label", caption = { "gui-settings.tasks-group-caption" }, style = "heading_2_label" }

  local table = group.add { type = "table", column_count = 2 }

  local label = table.add { type = "label", caption = { "gui-settings.clear-tasks-label" } }
  label.style.horizontally_stretchable = true

  local button = table.add {
    type = "sprite-button",
    name = "mission-tasks-setting-clear-tasks",
    sprite = "mission-tasks-rollback-white-icon",
    hovered_sprite  = "mission-tasks-rollback-white-icon",
    clicked_sprite  = "mission-tasks-rollback-white-icon",
    tooltip = { "gui-settings.clear-tasks-button-tooltip" },
    style = "red_slot_button"
  }
  button.style.padding = 2
  button.style.height = 28
  button.style.width = 28
end

local function draw_settings(player, parent)
  local titlebar = GuiHelper.create_titlebar(parent, parent, { "gui-settings.title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-settings-frame")

  local inner_frame = parent.add {
    type = "frame",
    direction = "horizontal",
    style = "inside_shallow_frame"
  }
  inner_frame.style.padding = 8

  local left_flow = inner_frame.add {
    type = "table",
    column_count = 1,
    style = "bordered_table"
  }
  left_flow.style.minimal_width = 256

  local right_flow = inner_frame.add {
    type = "table",
    column_count = 1,
    style = "bordered_table"
  }
  right_flow.style.minimal_width = 256


  -----------------------------------------------------------------------------
  -- Content
  -----------------------------------------------------------------------------

  draw_task_hud_settings(left_flow, player)
  draw_import_export_settings(right_flow)
  draw_tasks_settings(right_flow)

  -----------------------------------------------------------------------------

  GuiHelper.add_bottom_bar(parent, "mission-tasks-settings-frame")
end


-----------------------------------------------------------------------------
-- Settings Frame
-----------------------------------------------------------------------------

function SettingsFrame.draw(player)
  Gui.close_all_secondaries_frames(player)

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-settings-frame",
    direction = "vertical",
  }
  frame.auto_center = true

  draw_settings(player, frame)
  player.opened = frame
end

function SettingsFrame.destroy(player)
  local frame = player.gui.screen["mission-tasks-settings-frame"]
  if frame then frame.destroy() end
end

function SettingsFrame.redraw(player)
  if not (player.gui.screen["mission-tasks-settings-frame"] and player.gui.screen["mission-tasks-settings-frame"].valid) then return end

  local frame = player.gui.screen["mission-tasks-settings-frame"]
  frame.clear()
  draw_settings(player, frame)

end


--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function SettingsFrame.handle_click(player, element, gui)
  local name = element.name

  if name == "mission-tasks-open-settings-button" then
    SettingsFrame.draw(player)
    return true
  elseif name == "mission-tasks-setting-show-tasks-hud" then
    Settings.set(player.index, "show_tasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-setting-show-subtasks-hud" then
    Settings.set(player.index, "show_subtasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-setting-show-completed-subtasks-hud" then
    Settings.set(player.index, "show_completed_subtasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-setting-show-todo-tasks-hud" then
    Settings.set(player.index, "show_todo_tasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-setting-show-doing-tasks-hud" then
    Settings.set(player.index, "show_doing_tasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-setting-show-done-tasks-hud" then
    Settings.set(player.index, "show_done_tasks_hud", element.state)
    TaskHud.redraw(player)
    SettingsFrame.redraw(player)
    return true
  elseif name == "mission-tasks-settings-frame-close-button" or name == "mission-tasks-settings-frame-close-top-button" then
    SettingsFrame.destroy(player)
    return true
  elseif name == "mission-tasks-settings-export" then
    ExportFrame.draw(player)
    return true
  elseif name == "mission-tasks-settings-import" then
    ImportFrame.draw(player)
    return true
  elseif name == "mission-tasks-setting-clear-tasks" then
    ConfirmDialog.show(player, {
      title = {"gui-settings.clear-tasks-confirmation-title"},
      description = {"gui-settings.clear-tasks-confirmation-description"},
      confirm_name = "confirm-clear-all-tasks",
      on_confirm = function()
        Tasks.clear_tasks()
      end,
      on_cancel = function(player)
        -- opcional
      end
    })
    return true
  end

  return false
end

--- Handles selection state changes
--- @param player LuaPlayer
--- @param element LuaGuiElement
function SettingsFrame.handle_selection_state_changed(player, element)
  if not player or not element or not element.valid then return end

  local name = element.name

  if name == "mission-tasks-setting-font-size" then
    local val = FontSizeEnum.value_from_index(element.selected_index)
    Settings.set(player.index, "font_size", val)
    return true
  end

  return false
end


function SettingsFrame.handle_gui_value_changed(player, element)
  if not player or not element or not element.valid then return end
  local name = element.name

  local settings_frame = player.gui.screen["mission-tasks-settings-frame"]
  if name == "mission-tasks-setting-hud-opacity" then
    local val = element.slider_value
    Settings.set(player.index, "hud_opacity", val)

    local textfield = Gui.find_element(settings_frame, "mission-tasks-setting-hud-opacity-textfield")
    if textfield and textfield.valid then
      textfield.text = tostring(val) .. "%"
    end

    TaskHud.redraw(player)
    return true
  end
end
