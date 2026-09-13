if not Gui then Gui = {} end

function Gui.start()
  if not Gui then Gui = {} end
  storage.player_states = storage.player_states or {}
end

--- Initialize GUI for a player
--- @param player LuaPlayer
function Gui.init_player_gui(player)
  MainFrame.destroy(player)
  TaskFrame.destroy(player)
end

function Gui.update_task_view_panel(player, task_id)
  local task_detail_pane = MainFrame.getTaskDetailFrame(player)
  if not (task_detail_pane and task_detail_pane.valid) then return end
  TaskView.draw(task_detail_pane, task_id, player)
end

function Gui.close_all_secondaries_frames(player)
  local secondary_frames = {
    "mission-tasks-task-frame",
    "mission-tasks-subtask-frame",
    "mission-tasks-import-frame",
    "mission-tasks-export-frame",
    "mission-tasks-settings-frame",
    "mission-tasks-info-frame",
    "mission-tasks-confirm-frame"
  }

  local closed_any = false

  for _, frame_name in ipairs(secondary_frames) do
    local frame = player.gui.screen[frame_name]
    if frame and frame.valid then
      frame.destroy()
      closed_any = true
    end
  end

  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  if main_frame and main_frame.valid then
    player.opened = main_frame
  end

  return closed_any
end

function Gui.destroy_main_frame(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  if main_frame and main_frame.valid then main_frame.destroy() end
end

function Gui.destroy_all(player)
  Gui.close_all_secondaries_frames(player)
  Gui.destroy_main_frame(player)
end

function Gui.destroy_smart(player)
  local closed_secondary = Gui.close_all_secondaries_frames(player)

  if not closed_secondary then
    Gui.destroy_main_frame(player)
  end
end

--- Updates the TaskView for a player, and TaskList and TaskHud for all players
function Gui.refresh_tasks(player)
  local function _update_player_tasks(player)
    TaskView.redraw(player)
    TaskList.redraw()
    TaskHud.redraw()
  end

  if (not player) then
    for _, player in pairs(game.players) do
      _update_player_tasks(player)
    end
  else
    _update_player_tasks(player)
  end
end

---@param parent LuaGuiElement
---@param name string
---@return LuaGuiElement|nil
function Gui.find_element(parent, name)
  if not parent or not parent.valid then return nil end

  -- Se o elemento atual tem o nome desejado, retorna ele
  if parent.name == name then
    return parent
  end

  -- Percorre os filhos recursivamente
  for _, child in pairs(parent.children) do
    local found = Gui.find_element(child, name)
    if found then
      return found
    end
  end

  return nil -- Se não encontrar
end
