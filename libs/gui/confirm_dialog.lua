if not ConfirmDialog then ConfirmDialog = {} end

-- Table to store callbacks per player
local confirm_callbacks = {}

--- Shows a standard confirmation dialog
--- @param player LuaPlayer
--- @param options table {
---   title: string,
---   description: string,
---   confirm_name: string,
---   on_confirm: function,
---   on_cancel?: function,
---   variant?: 'danger', 'success',
---   confirm_caption?: string
--- }
function ConfirmDialog.show(player, options)
  ConfirmDialog.destroy(player)

  local screen = player.gui.screen
  local frame = screen.add {
    type = "frame",
    name = "mission-tasks-confirm-frame",
    direction = "vertical"
  }
  frame.auto_center = true
  frame.style.width = 300

  frame.add {
    type = "label",
    caption = options.title or "Tem certeza?",
    style = "heading_2_label"
  }

  local inner_frame = frame.add {
    type = "frame",
    style = "inside_shallow_frame",
    direction = "vertical"
  }
  inner_frame.style.padding = 8

  local label = inner_frame.add {
    type = "label",
    caption = options.description,
  }
  label.style.single_line = false
  label.style.horizontally_stretchable = true

  local button_flow = frame.add {
    type = "flow",
    direction = "horizontal"
  }
  button_flow.style.top_margin = 8

  button_flow.add {
    type = "button",
    name = "mission-tasks-cancel-confirm-dialog",
    caption = { "gui.cancel" },
    style = "back_button"
  }

  local dragger = button_flow.add { type = "empty-widget" }
  dragger.style.horizontally_stretchable = true

  button_flow.add{
    type = "button",
    name = options.confirm_name,
    caption = confirm_caption or { "gui.confirm" },
    style = (options.variant == "danger" and "red_confirm_button") or (options.variant == "success" and  "confirm_button") or "red_confirm_button"
  }

  -- Saves callbacks
  confirm_callbacks[player.index] = {
    confirm_name = options.confirm_name,
    on_confirm = options.on_confirm,
    on_cancel = options.on_cancel
  }
end

--- Destroys the dialog if it is open
--- @param player LuaPlayer
function ConfirmDialog.destroy(player)
  local frame = player.gui.screen["mission-tasks-confirm-frame"]
  if frame then frame.destroy() end
  confirm_callbacks[player.index] = nil
end

--- Handles click events on dialog buttons
--- @param player LuaPlayer
--- @param element LuaGuiElement
function ConfirmDialog.handle_click(player, element)
  local callback = confirm_callbacks[player.index]
  if not callback then
    ConfirmDialog.destroy(player)
    return false
  end

  local name = element.name

  -- Cancel
  if name == "mission-tasks-cancel-confirm-dialog" then
    if callback.on_cancel then callback.on_cancel(player) end
    ConfirmDialog.destroy(player)
    return true
  end

  -- Confirm
  if element.type == "button" and name == callback.confirm_name then
    if callback.on_confirm then callback.on_confirm(player, name) end
    ConfirmDialog.destroy(player)
    return true
  end

  return false
end
