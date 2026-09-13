ExportFrame = {}

--- Draws the new/edit task frame.
--- @param player LuaPlayer
--- @param task? table
--- @param index? integer
function ExportFrame.draw(player)
  Gui.close_all_secondaries_frames(player)

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-export-frame",
    direction = "vertical",
  }
  frame.auto_center = true

  local titlebar = GuiHelper.create_titlebar(frame, frame, { "export-frame.title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-export-frame")

  ------------------------------------------------
  -- CONTENT
  ------------------------------------------------

  local inner_frame = frame.add {
    type = "frame",
    direction = "vertical",
    style = "inside_shallow_frame_with_padding",
  }
  inner_frame.style.horizontally_stretchable = true

  inner_frame.add {
    type = "label",
    caption = { "export-frame.export-string-label" }
  }

  local textbox = inner_frame.add {
    type = "text-box",
    name = "mission-tasks-export-frame-title-textfield",
    text = ExpImpHelper.export(),
    style = "editor_lua_textbox",
    single_line = false
  }
  textbox.style.height = 320
  textbox.style.width = 480

  ------------------------------------------------

  GuiHelper.add_bottom_bar(frame, "mission-tasks-export-frame", { "export-frame.close-button" })
end

--- Destroy the task frame.
--- @param player LuaPlayer
function ExportFrame.destroy(player)
  local frame = player.gui.screen["mission-tasks-export-frame"]
  if frame then frame.destroy() end
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function ExportFrame.handle_click(player, element)
  local name = element.name

  if name == "mission-tasks-export-frame-close-top-button" or name == "mission-tasks-export-frame-close-button" then
    ExportFrame.destroy(player)
    SettingsFrame.draw(player)
    return true
  end

  return false
end
