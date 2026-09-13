if not Settings then Settings = {} end

--------------------------------------------------------------------------------
-- Life‑cycle
--------------------------------------------------------------------------------
local DEFAULTS = {
  show_tasks_hud              = true,                 -- show tasks on hud?
  show_subtasks_hud           = true,                 -- show subtasks on hud?
  show_completed_subtasks_hud = true,                 -- show completed subtasks on hud?
  show_todo_tasks_hud         = true,                 -- show todo tasks on hud?
  show_doing_tasks_hud        = true,                 -- show doing tasks on hud?
  show_done_tasks_hud         = false,                -- show done tasks on hud?
  hud_opacity                 = 0,                    -- 0-100
  font_size                   = FontSizeEnum.MEDIUM,  -- small | medium | large
}

function Settings.start()
  storage.settings = storage.settings or {}
end

--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------
--- Garante uma tabela de configuração para o player
--- @param player_index integer
--- @return table
local function ensure_player_settings(player_index)
  local current = storage.settings[player_index] or {}
  for key, value in pairs(DEFAULTS) do
    if current[key] == nil then
      current[key] = value
    end
  end
  storage.settings[player_index] = current
  return current
end

--------------------------------------------------------------------------------
-- CRUD
--------------------------------------------------------------------------------
--- Obtém as configurações de um jogador
--- @param player_index integer
--- @return table
function Settings.get(player_index)
  return ensure_player_settings(player_index)
end

--- Atualiza um campo e persiste no storage
--- @param player_index integer
--- @param field string
--- @param value any
function Settings.set(player_index, field, value)
  local setting = ensure_player_settings(player_index)
  local player = game.get_player(player_index)

  if setting[field] ~= value then
    setting[field] = value
    -- ajustes imediatos na GUI, se necessário
    if field == "show_tasks_hud" then
      if value then
        TaskHud.redraw(player)
      else
        TaskHud.destroy(player)
      end
    elseif field == "show_subtasks_hud" then
      TaskHud.redraw(player)
    elseif field == "show_completed_subtasks_hud" then
      TaskHud.redraw(player)
    elseif field == "font_size" then
      TaskHud.redraw(player)
    end
  end
end
