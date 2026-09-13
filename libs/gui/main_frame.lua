MainFrame = {}

--- Draws the main tasks frame.
--- @param player LuaPlayer
function MainFrame.draw(player)
  if player.gui.screen["mission-tasks-main-frame"] then
    player.gui.screen["mission-tasks-main-frame"].destroy()
    return
  end

  local frame = player.gui.screen.add {
    type = "frame",
    name = "mission-tasks-main-frame",
    direction = "vertical",
  }
  frame.auto_center = true
  frame.style.height = 600

  local titlebar = GuiHelper.create_titlebar(frame, frame, {"gui-main-frame.title"})

  -- Info button
  titlebar.add{
    type   = "sprite-button",
    name   = "mission-tasks-main-frame-info-top-button",
    style  = "frame_action_button",
    sprite = "mission-tasks-info-white-icon",
    hovered_sprite  = "mission-tasks-info-white-icon",
    clicked_sprite  = "mission-tasks-info-white-icon",
    tooltip = { "gui.info-button-tooltip" }
  }

  -- Config button
  titlebar.add{
    type   = "sprite-button",
    name   = "mission-tasks-open-settings-button",
    style  = "frame_action_button",
    sprite = "mission-tasks-cog-white-icon",
    hovered_sprite  = "mission-tasks-cog-white-icon",
    clicked_sprite  = "mission-tasks-cog-white-icon",
    tooltip = { "gui.config-button-tooltip" }
  }

  GuiHelper.add_close_button(titlebar, "mission-tasks-main-frame")

  ------------------------------------------------
  -- CONTENT
  ------------------------------------------------

  local content_flow = frame.add {
    type = "flow",
    direction = "horizontal"
  }

  -- Left Frame - Tasks
  local tabbed_pane_frame = content_flow.add {
    type = "frame",
    name = "mission-tasks-tabbed-pane-frame",
    direction = "vertical",
    style = "inside_deep_frame",
  }
  tabbed_pane_frame.style.right_margin = 4
  tabbed_pane_frame.style.width = 400

  TaskList.render_all(player, tabbed_pane_frame)

  -- Right Frame - Details
  local task_detail_pane = content_flow.add {
    type = "frame",
    name = "mission-tasks-task-detail-frame",
    direction = "vertical",
    style = "inside_deep_frame",
  }
  task_detail_pane.style.vertically_stretchable = true
  task_detail_pane.style.left_margin = 4
  task_detail_pane.style.width = 600

  -- Bottom Frame
  local bottom_flow = frame.add {
    type = "flow",
    direction = "horizontal"
  }
  bottom_flow.style.top_margin = 8

  bottom_flow.add {
    type = "button",
    name = "mission-tasks-main-frame-close-button",
    style = "red_back_button",
    caption = { "gui-main-frame.close-button" }
  }

  local dragger = bottom_flow.add { type = "empty-widget", style = "draggable_space" }
  dragger.style.horizontally_stretchable = true
  dragger.style.height = 32
  dragger.drag_target = frame

  local add_task_button = bottom_flow.add {
    type = "button",
    name = "mission-tasks-main-frame-add-task-button",
    caption = { "gui-main-frame.new-task-button" },
    style = "green_button"
  }
  add_task_button.style.height = 32
  add_task_button.style.font = "default-large-semibold"

  player.opened = frame
end

--- Destroy the main frame.
--- @param player LuaPlayer
function MainFrame.destroy(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  if main_frame then main_frame.destroy() end
end

--- Reloads the task tables and tabs.
--- @param player LuaPlayer
--- @param gui table
function MainFrame.reload_tasks(player)
  local tabbed_pane_frame = MainFrame.getTabbedPaneFrame(player)
  if not (tabbed_pane_frame and tabbed_pane_frame.valid) then return end

  TaskList.render_all(player, tabbed_pane_frame)
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function MainFrame.handle_click(player, element, gui)
  local name = element.name

  if name == "mission-tasks-main-frame-add-task-button" then -- Open task frame for adding
    TaskFrame.draw(player, "new")
    return true
  elseif name == "mission-tasks-main-frame-close-button" then -- Close main frame
    MainFrame.destroy(player)
    return true
  elseif name == "mission-tasks-main-frame-close-top-button" then
    MainFrame.destroy(player)
    return true
  elseif name == "mission-tasks-main-frame-info-top-button" then
    InfoFrame.draw(player)
    return true
  end

  return false
end

function MainFrame.getTabbedPaneFrame(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  if not (main_frame and main_frame.valid) then return end
  return Gui.find_element(main_frame, "mission-tasks-tabbed-pane-frame")
end

function MainFrame.getTaskDetailFrame(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  if not (main_frame and main_frame.valid) then return end
  return Gui.find_element(main_frame, "mission-tasks-task-detail-frame")
end
