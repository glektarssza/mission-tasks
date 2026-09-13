TaskList = {}


local function make_item_caption(task)
  local icon = SpriteHelper.icon_rich_text(task.icon) or "[img=virtual-signal/map-pin-white]"

  local assignee_name = "—"
  if task.assigned_id then
    if task.assigned_id == -1 then
      assignee_name = {"gui-task-view-assignee.everyone"}
    else
      local p = game.get_player(task.assigned_id)
      if p and p.valid then
        assignee_name = p.name
      end
    end
  end

  -- Usando concatenação ao invés de string.format para suportar strings localizadas
  return {
    "", -- String vazia indica concatenação de rich text
    icon,
    " [font=default-bold]",
    task.title,
    "[/font] [color=#808080][",
    assignee_name,
    "][/color]"
  }
end

--- Creates a tab and returns it.
--- @param pane LuaGuiElement
--- @param caption string
--- @param status string "todo" | "doing" | "done"
function TaskList.draw(player, pane, caption, status)
  local tasks = Tasks.get_tasks({ status = { status } })

  local tab = pane.add {
    type = "tab",
    caption = caption,
    badge_text = #tasks
  }

  local content = pane.add {
    type = "flow",
    name = "mission-tasks-tab-content-" .. status,
    direction = "vertical"
  }

  local listbox = content.add {
    type = "list-box",
    name = "mission-tasks-task-listbox-" .. status,
    items = {},
  }
  listbox.style.horizontally_stretchable = true
  listbox.style.vertically_stretchable = true

  local task_ids = {}

  local selected_task_id = State.get_selected_task_id(player)

  for _, task in ipairs(tasks) do
    listbox.add_item(make_item_caption(task))
    table.insert(task_ids, task.id)
    if task.id == selected_task_id then
      listbox.selected_index = #task_ids
    end
  end

  listbox.tags = { task_ids = task_ids, status = status }

  pane.add_tab(tab, content)

  return {
    tab = tab,
    listbox = listbox
  }
end

--- Renders the full tabbed-pane with all task statuses
--- @param player LuaPlayer
--- @param parent LuaGuiElement
function TaskList.render_all(player, parent)
  if not parent or not parent.valid then return end
  parent.clear()

  local tabbed_pane = parent.add {
    type = "tabbed-pane",
    name = "mission-tasks-tabbed-pane",
    style = "tabbed_pane_with_extra_padding",
  }
  tabbed_pane.style.horizontally_stretchable = true
  tabbed_pane.style.vertically_stretchable = true

  TaskList.draw(player, tabbed_pane, { "gui-task-view.todo-task-list-caption" }, "todo")
  TaskList.draw(player, tabbed_pane, { "gui-task-view.doing-task-list-caption" }, "doing")
  TaskList.draw(player, tabbed_pane, { "gui-task-view.done-task-list-caption" }, "done")

  local selected_task = State.get_selected_task(player)
  local selected_pane = 1
  if selected_task and selected_task.valid and selected_task.status then
    selected_pane = StatusEnum.index_from_value(selected_task.status)
  end
  tabbed_pane.selected_tab_index = selected_pane
end


--- Handles selection state changes
--- @param player LuaPlayer
--- @param element LuaGuiElement
function TaskList.handle_selection_state_changed(player, element)
  if not player or not element or not element.valid then return end

  local name = element.name

  if name:match("^mission%-tasks%-task%-listbox%-") then
    local selected_index = element.selected_index
    if selected_index < 1 then return end

    local task_ids = element.tags.task_ids
    local task_id = task_ids[selected_index]

    if task_id and player then
      State.update_selected_task_id(player, task_id)
      Gui.update_task_view_panel(player, task_id)
    end

    local tabbed_pane = element.parent.parent

    -- Deselect all other list boxes
    for _, child in pairs(tabbed_pane.children) do
      if child ~= element.parent and child.valid then
        for _, other in pairs(child.children) do
          if other.type == "list-box" and other.name ~= element.name then
            other.selected_index = 0
          end
        end
      end
    end
    return true
  end

  return false
end

--- Redraws the Task List
--- @param player? LuaPlayer
function TaskList.redraw(player)
  if not player then
    for _, p in pairs(game.players) do
      TaskList.redraw(p)
    end
    return
  end
  local selected_task = State.get_selected_task(player)

  MainFrame.reload_tasks(player)

  if (not selected_task) then return end
  local tabbed_pane_frame = MainFrame.getTabbedPaneFrame(player)
  if not (tabbed_pane_frame and tabbed_pane_frame.valid) then return end
  if #tabbed_pane_frame.children > 0 and tabbed_pane_frame.children[1].valid then
    local tabbed_pane = tabbed_pane_frame.children[1]
    tabbed_pane.selected_tab_index = StatusEnum.index_from_value(selected_task.status)
  end
end
