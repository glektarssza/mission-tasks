InfoFrame = {}

--- Draws the info task frame.
--- @param player LuaPlayer
function InfoFrame.draw(player)
  Gui.close_all_secondaries_frames(player)

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-info-frame",
    direction = "vertical",
  }
  frame.auto_center = true
  frame.style.width = 300

  local titlebar = GuiHelper.create_titlebar(frame, frame, { "gui-info-frame.title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-info-frame")

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
    caption = { "", "Mission Tasks v", script.active_mods["mission-tasks"] }
  }

  local label = inner_frame.add {
    type = "label",
    caption = "Thank you for using the Mission Tasks mod! I hope it helps you stay organized and focused on building factories."
  }
  label.style.single_line = false
  label.style.top_margin = 8

  ------------------------------------------------

  GuiHelper.add_bottom_bar(frame, "mission-tasks-info-frame")

  player.opened = frame
end

--- Destroy the frame.
--- @param player LuaPlayer
function InfoFrame.destroy(player)
  local frame = player.gui.screen["mission-tasks-info-frame"]
  if frame then frame.destroy() end
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function InfoFrame.handle_click(player, element)
  local name = element.name

  if name == "mission-tasks-info-frame-close-top-button" or name == "mission-tasks-info-frame-close-button" then -- Close main frame
    InfoFrame.destroy(player)
    return true
  end

  return false
end
