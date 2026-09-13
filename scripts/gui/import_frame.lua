ImportFrame = {}

--- Draws the new/edit task frame.
--- @param player LuaPlayer
--- @param task? table
--- @param index? integer
function ImportFrame.draw(player)
  Gui.close_all_secondaries_frames(player)

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-import-frame",
    direction = "vertical",
  }
  frame.auto_center = true

  local titlebar = GuiHelper.create_titlebar(frame, frame, { "import-frame.title" })
  GuiHelper.add_close_button(titlebar, "mission-tasks-import-frame")

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
    caption = { "import-frame.import-string-label" }
  }

  local textbox = inner_frame.add {
    type = "text-box",
    name = "mission-tasks-import-frame-title-textfield",
    text = "",
    style = "editor_lua_textbox",
    single_line = false
  }
  textbox.style.height = 320
  textbox.style.width = 480

  ------------------------------------------------

  local bottom_frame_flow = GuiHelper.add_bottom_bar(frame, "mission-tasks-import-frame", { "import-frame.close-button" } )

  bottom_frame_flow.add {
    type = "button",
    name = "mission-tasks-import-frame-import-button",
    style = "confirm_button",
    caption = { "import-frame.import-button" }
  }
end

--- Destroy the task frame.
--- @param player LuaPlayer
function ImportFrame.destroy(player)
  local frame = player.gui.screen["mission-tasks-import-frame"]
  if frame then frame.destroy() end
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function ImportFrame.handle_click(player, element)
  if not (element and element.valid) then return end
  local name = element.name

  if name == "mission-tasks-import-frame-import-button" then
    local textfield = player.gui.screen["mission-tasks-import-frame"].children[2]["mission-tasks-import-frame-title-textfield"]
    local data = textfield.text
    local tasks = ExpImpHelper.import(data)

    for k, v in pairs(tasks) do
      v.status = StatusEnum.TODO
      v.assigned_id = nil
      v.location = nil

      Tasks.add_task(player, v)
    end

    ImportFrame.destroy(player)
    SettingsFrame.draw(player)
    return true
  elseif name == "mission-tasks-import-frame-close-button" or name == "mission-tasks-import-frame-close-top-button"then
    ImportFrame.destroy(player)
    SettingsFrame.draw(player)
    return true
  end

  return false
end
