TaskViewComments = {}

--- Renders the combined history and comments timeline sorted by tick.
--- @param parent LuaGuiElement
--- @param task table
function TaskViewComments.draw(parent, task)
  local section = parent.add {
    type = "frame",
    direction = "vertical",
    style = "deep_frame_in_shallow_frame_for_description",
  }
  section.style.padding = 6
  section.style.horizontally_stretchable = true

  section.add {
    type = "label",
    caption = {"gui-task-view-comments.timeline"},
    style = "heading_2_label"
  }

  local comment_textbox = section.add {
    type = "text-box",
    name = "mission-tasks-task-comment-textbox",
    word_wrap = true,
    style = "editor_lua_textbox",
  }
  comment_textbox.style.height = 64

  local comment_buttons_flow = section.add { type = "flow", direction = "horizontal" }
  local comment_button_spacer = comment_buttons_flow.add {
    type = "empty-widget",
  }
  comment_button_spacer.style.horizontally_stretchable = true
  comment_buttons_flow.add {
    type = "button",
    name = "mission-tasks-task-comment-button",
    caption = {"gui-task-view-comments.comment"},
  }

  local separator = section.add { type = "line" }
  separator.style.horizontally_stretchable = true
  separator.style.top_margin = 8
  separator.style.bottom_margin = 8

  local timeline = {}

  for _, comment in ipairs(task.comments or {}) do
    table.insert(timeline, {
      type = "comment",
      tick = comment.tick,
      player = comment.player,
      text = comment.text,
    })
  end

  for _, change in ipairs(task.history or {}) do
    table.insert(timeline, {
      type = "history",
      tick = change.tick,
      player = change.player,
      field = change.field,
      from = change.from,
      to = change.to,
    })
  end

  local owner = PlayerHelper.get_player_by_id(task.owner_id)
  table.insert(timeline, {
      type = "creation",
      tick = task.created_at,
      player = owner and owner.name or {"gui-task-view-comments.unknown"},
      field = nil,
      from = nil,
      to = nil,
    })

  table.sort(timeline, function(a, b) return a.tick > b.tick end)

  for _, entry in ipairs(timeline) do
    local entry_player = game.get_player(entry.player)
    local player_name = entry_player and entry_player.name or {"gui-task-view-comments.unknown"}

    local frame = section.add {
      type = "frame",
      direction = "vertical",
      style = "shallow_frame",
    }
    frame.style.padding = 1
    frame.style.horizontally_stretchable = true

    if entry.type == "comment" then
      local label = frame.add {
        type = "label",
        caption = string.format("%s: %s", player_name, entry.text)
      }
      label.style.single_line = false

    elseif entry.type == "history" then

      local value = entry.to
      local field = entry.field
      local caption = {}

      if entry.field == "assigned_id" then
        local task_player = PlayerHelper.get_player_by_id(entry.to)
        if task_player and task_player.name then
          caption = {"gui-task-view-comments.modify-history-assignee", player_name, task_player.name}
        else
          caption = {"gui-task-view-comments.modify-history-unassignee", player_name}
        end
      elseif entry.field == "subtasks" then
        frame.destroy()
        goto continue
      else
        caption = {"gui-task-view-comments.modify-history-general", player_name, field, tostring(value)}
      end

      local label = frame.add {
        type = "label",
        caption = caption,
      }
      label.style.font = "default-small"
      label.style.font_color = { r = 0.6, g = 0.6, b = 0.6 }
    elseif entry.type == "creation" then
      local label = frame.add {
        type = "label",
        caption = {"gui-task-view-comments.creation-history", player_name},
      }
      label.style.font = "default-small"
      label.style.font_color = { r = 0.6, g = 0.6, b = 0.6 }
    end

    local tick_label = frame.add {
      type = "label",
      caption = FormatElapsedTime(entry.tick),
    }
    tick_label.style.font = "default-small"
    tick_label.style.font_color = { r = 0.5, g = 0.5, b = 0.5 }

    ::continue::
  end

  return {
    comment_textbox = comment_textbox,
  }
end
