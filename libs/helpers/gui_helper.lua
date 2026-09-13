GuiHelper = {}

function GuiHelper.create_titlebar(parent, frame, title_text)
  local titlebar = parent.add{ type = "flow", direction = "horizontal" }
  titlebar.drag_target = frame

  titlebar.add{
    type = "label",
    caption = title_text,
    style = "frame_title"
  }

  local drag = titlebar.add{ type = "empty-widget", style = "draggable_space_header" }
  drag.style.horizontally_stretchable = true
  drag.style.height = 24
  drag.drag_target = frame

  return titlebar
end

function GuiHelper.add_close_button(titlebar, frame_name)
  titlebar.add{
    type = "sprite-button",
    name = frame_name .. "-close-top-button",
    sprite = "mission-tasks-cross-white-icon",
    style = "frame_action_button",
    tooltip = {"gui.close"}
  }
end

--- Adds a close button to the bottom of the frame
--- @param frame Frame to add the button to
--- @param frame_name Name of the frame
--- @param close_button_caption? string|LocalisedString
function GuiHelper.add_bottom_bar(frame, frame_name, close_button_caption)
  local flow = frame.add {
    type = "flow",
    direction = "horizontal"
  }
  flow.style.top_margin = 8

  flow.add {
    type = "button",
    name = frame_name .. "-close-button",
    style = "back_button",
    caption = close_button_caption or { "gui.close" }
  }

  local dragger = flow.add { type = "empty-widget", style = "draggable_space" }
  dragger.style.horizontally_stretchable = true
  dragger.style.height = 32
  dragger.drag_target = frame

  return flow
end

---comment
---@param parent any
---@param params? table { height?: number }
function GuiHelper.add_vertical_divider(parent, params)
  local divider = parent.add { type = "line", direction = "vertical" }
  divider.style.height = params and params.height or 24
  divider.style.vertically_stretchable = false
end
