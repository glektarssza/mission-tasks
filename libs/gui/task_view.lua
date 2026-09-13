require("scripts.gui.task_view_header")
require("scripts.gui.task_view_status")
require("scripts.gui.task_view_assignee")
require("scripts.gui.task_view_location")
require("scripts.gui.task_view_comments")
require("scripts.gui.task_view_subtasks")

TaskView = {}

--- Reloads the task list.
--- @param player LuaPlayer
local function _reload(player)
  if not (player and player.valid) then return end
  local task_detail_pane = MainFrame.getTaskDetailFrame(player)
  if not (task_detail_pane and task_detail_pane.valid) then return end
  TaskView.draw(task_detail_pane, State.get_selected_task_id(player), player)
end

--- Desenha lista de tasks em um container qualquer da GUI.
--- @param parent LuaGuiElement
--- @param id? integer
--- @param player LuaPlayer
function TaskView.draw(parent, id, player)
  if not id or not parent or not parent.valid then return end

  parent.clear()

  local task = Tasks.get_task(id)
  if not task then
    local frame = parent.add { type = "frame", direction = "horizontal", style = "inside_deep_frame" }
    frame.style.horizontally_stretchable = true
    frame.style.vertically_stretchable = true
    return
  end

  -- Header
  TaskViewHeader.draw(parent, task)

  -- Body
  local body = parent.add {
    type = "frame",
    direction = "vertical",
    style = "inside_shallow_frame",
    name = "mission-tasks-task-view-body"
  }

  local scroll_pane = body.add {
    type = "scroll-pane",
    direction = "vertical",
    name = "mission-tasks-task-view-scroll-pane",
    style = "scroll_pane_in_shallow_frame",
    horizontal_scroll_policy = "never"
  }

  scroll_pane.style.horizontally_stretchable = true
  scroll_pane.style.vertically_stretchable = true
  scroll_pane.style.padding = 8

  local table = scroll_pane.add {
    type = "table",
    column_count = 2,
  }
  table.style.vertically_stretchable = true

  -- Description
  table.add { type = "label", caption = {"" , {"gui-task-view.description-label"} , ": "}, style = "caption_label" }
  local desc = table.add { type = "label", caption = task.desc }
  desc.style.single_line = false

  -- Status
  TaskViewStatus.draw(table, task)

  -- Assign
  TaskViewAssignee.draw(table, task)

  -- Icon
  table.add { type = "label", caption = {"" , {"gui-task-view-location.icon-label"} , ": "}, style = "caption_label" }
  table.add {
    type = "choose-elem-button",
    name = "mission-tasks-icon-selector",
    elem_type = "signal",
    -- elem_type = "space-location",
    -- elem_type = "item",
    signal = task.icon or { type = "virtual", name = "map-pin-white" },
    tooltip = {"gui-task-view-location.icon-tooltip"},
  }

  -- Location
  local task_location = TaskViewLocation.draw(table, task)

  local line = scroll_pane.add { type = "line", direction = "horizontal" }
  line.style.horizontally_stretchable = true
  line.style.top_margin = 8
  line.style.bottom_margin = 8

  -- Subtasks
  TaskViewSubtasks.draw(player, scroll_pane, task)

  local line = scroll_pane.add { type = "line", direction = "horizontal" }
  line.style.horizontally_stretchable = true
  line.style.top_margin = 8
  line.style.bottom_margin = 8

  -- Task timeline
  local task_comment = TaskViewComments.draw(scroll_pane, task)
end

--- Redraws the task HUD
--- @param player? LuaPlayer
function TaskView.redraw(player)
  if not player then
    for _, player in pairs(game.players) do
      _reload(player, gui)
    end
  else
    _reload(player)
  end
end

--- Gets the comment textbox
--- @param player LuaPlayer
--- @param text string
function TaskView.get_comment_textbox(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  local element = Gui.find_element(main_frame, "mission-tasks-task-comment-textbox")
  return element
end

--- Gets the subtask_textfield
--- @param player LuaPlayer
--- @param text string
function TaskView.get_subtask_textfield(player)
  local main_frame = player.gui.screen["mission-tasks-main-frame"]
  local element = Gui.find_element(main_frame, "mission-tasks-subtask-title")
  return element
end

-------------------------------------------------------------------------------
-- Events
-------------------------------------------------------------------------------

--- Handles click events on dialog buttons
--- @param event LuaEvent
--- @param player LuaPlayer
--- @param element LuaGuiElement
--- @param gui table
function TaskView.handle_click(event, player, element, gui)
  local name = element.name
  local edit_frame_prefix = "mission-tasks-task-frame-edit-task-button-"

  if name == "mission-tasks-edit-task-button" then -- Open task frame for editing
    local task_id = State.get_selected_task_id(player)
    if task_id then
      local task = Tasks.get_task(task_id)
      TaskFrame.draw(player, "edit", task, task_id)
    end
    return true
  elseif name == "mission-tasks-duplicate-task-button" then -- Duplicate task
    local task_id = State.get_selected_task_id(player)
    if task_id then
      local task = Tasks.get_task(task_id)
      TaskFrame.draw(player, "copy", task, task_id)
    end
    return true
  elseif name == "mission-tasks-delete-task-button" then -- Delete task
    local task_id = State.get_selected_task_id(player)
    if task_id then
      ConfirmDialog.show(player, {
        title = {"confirm-dialogs.delete-task-title"},
        description = {"confirm-dialogs.delete-task-description"},
        confirm_name = "confirm-delete-task-" .. task_id,
        on_confirm = function()
          Tasks.remove_task(player, task_id)
        end,
        on_cancel = function(player)
          -- opcional
        end
      })
    end
    return true
  elseif name == "mission-tasks-increase-priority-button" then -- Increase task priority
    local task_id = State.get_selected_task_id(player)
    if task_id then
      if event.shift then
        Tasks.move_task_priority(player, task_id, "top")
      else
        Tasks.move_task_priority(player, task_id, "up")
      end
    end
    return true
  elseif name == "mission-tasks-decrease-priority-button" then -- Decrease task priority
    local task_id = State.get_selected_task_id(player)
    if task_id then
      if event.shift then
        Tasks.move_task_priority(player, task_id, "bottom")
      else
        Tasks.move_task_priority(player, task_id, "down")
      end
    end
    return true

  elseif name:find(edit_frame_prefix, 1, true) == 1 then -- Edit task
    local task_id = tonumber(name:sub(#edit_frame_prefix + 1))
    if task_id then
      Tasks.update_task(player, task_id, {
        title  = gui.task_frame.task_title.text,
        desc   = gui.task_frame.task_description.text,
        status = StatusEnum.value_from_index(gui.task_frame.task_status.selected_index),
      })

      TaskFrame.destroy(player)
      Gui.refresh_tasks()
    end
    return true
  elseif name == "mission-tasks-task-comment-button" then --Comment on a task
    local task_id = State.get_selected_task_id(player)
    if task_id then
      local textbox = TaskView.get_comment_textbox(player)

      if textbox and textbox.valid and textbox.text and textbox.text ~= "" then
        Tasks.add_coments(player, task_id, textbox.text)
      end
      if textbox and textbox.valid and textbox.text and textbox.text ~= "" then
        textbox.text = ""
      end
    end
    return true
  elseif name == "mission-tasks-show-on-map" then
    local task_id = State.get_selected_task_id(player)
    local show = element.state
    Tasks.update_show_on_map(player, task_id, show)
    return true
  elseif name == "mission-tasks-edit-location-button" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end

    State.update_pending_location_task_id(player, task_id)

    -- Dá a ferramenta ao jogador
    local stack = { name = "task-location-selector", count = 1 }
    player.insert(stack)
    player.cursor_stack.set_stack(stack)

    MainFrame.destroy(player)
    return true
  elseif name == "mission-tasks-remove-location-button" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end

    ConfirmDialog.show(player, {
      title = {"confirm-dialogs.restore-task-location-title"},
      description = {"confirm-dialogs.restore-task-location-description"},
      confirm_name = "confirm-restore-task-location-" .. task_id,
      on_confirm = function()
        Tasks.remove_location(player, task_id)
      end,
      on_cancel = function(player)
        -- opcional
      end
    })
    return true
  elseif name == "mission-tasks-open-location-button" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end


    local location = Tasks.get_location(task_id)
    local position, surface = location.position, location.surface

    player.print("[gps=" .. position.x .. "," .. position.y .. "," .. surface .. "]")
    return true
  end

  return false
end

--- Handles element changes
--- @param player LuaPlayer
--- @param element LuaGuiElement
function TaskView.handle_element_changed(player, element)
  local name = element.name

  if name == "mission-tasks-icon-selector" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end

    Tasks.update_icon(player, task_id, element.elem_value)
    return true
  end

  return false
end

--- Handles selection state changes
--- @param player LuaPlayer
--- @param element LuaGuiElement
function TaskView.handle_selection_state_changed(player, element)
  if not player or not element or not element.valid then return end

  local name = element.name

  if name == "mission-tasks-assign-dropdown" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end

    local selected_index = element.selected_index
    if (selected_index == 1) then -- Unassigned
      Tasks.update_assigned_id(player, task_id, nil)
      return
    elseif (selected_index == 2) then -- Everyone
      Tasks.update_assigned_id(player, task_id, -1)
      return
    end

    local selected_name = element.get_item(selected_index)
    local assigned_player = PlayerHelper.get_player_by_name(selected_name)
    local task = Tasks.get_task(task_id)

    if not task then return end

    Tasks.update_assigned_id(player, task_id, assigned_player and assigned_player.index or nil)

    return true
  elseif name == "mission-tasks-status-dropdown" then
    local task_id = State.get_selected_task_id(player)
    if not task_id then return end

    local selected_index = element.selected_index
    local status = StatusEnum.value_from_index(selected_index)
    if status then
      Tasks.update_status(player, task_id, status)
    end
    return true
  end

  return false
end
