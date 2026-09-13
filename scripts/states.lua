if not State then State = {} end

--------------------------------------------------------------------------------
-- Life‑cycle
--------------------------------------------------------------------------------
local DEFAULTS = {
  selected_task_id      = nil,
  selected_subtask_id   = nil,
  pending_location_edit = nil,
}

function State.start()
  if not State then State = {} end
  storage.player_states = storage.player_states or {}
end

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

--- Ensures the GUI for the player exists.
--- @param player LuaPlayer
function State.ensure_player_state(player)
  if not player or not player.valid then return end

  if not storage.player_states then
    storage.player_states = {}
  end

  local current = storage.player_states[player.index] or {}
  for key, value in pairs(DEFAULTS) do
    if current[key] == nil then
      current[key] = value
    end
  end
  storage.player_states[player.index] = current
  return current
end

function State.update_selected_task_id(player, task_id)
  local player_state = State.ensure_player_state(player)
  player_state.selected_task_id = task_id
  TaskView.redraw(player)
end

function State.get_selected_task_id(player)
  local player_state = State.ensure_player_state(player)
  return player_state.selected_task_id or nil
end

function State.get_selected_task(player)
  local player_state = State.ensure_player_state(player)
  local task_id = player_state.selected_task_id
  return task_id and Tasks.get_task(task_id) or nil
end

function State.update_pending_location_task_id(player, task_id)
  local player_state = State.ensure_player_state(player)
  player_state.pending_location_edit = task_id
  TaskView.redraw(player)
end
