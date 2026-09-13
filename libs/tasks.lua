if not Tasks then Tasks = {} end

--------------------------------------------------------------------------------
-- Life-cycle
--------------------------------------------------------------------------------
local default_location = { position = { x = 0, y = 0 }, surface = "nauvis" }

function Tasks.start()
  storage.tasks = storage.tasks or {}
  storage.task_id_counter = storage.task_id_counter or 0
end


--------------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------------

--- Generic utility to generate an id for tasks
--- @return number
local function generate_id()
  storage.task_id_counter = storage.task_id_counter + 1
  return storage.task_id_counter
end

--- Generic utility to generate an id for subtasks
--- @param task table
--- @return number
local function generate_subtask_id(task)
  task._sub_id_counter = (task._sub_id_counter or 0) + 1
  return task._sub_id_counter
end

--- Generic utility to find the index of a task by identifier
--- @param id number
--- @return number
local function find_task_index(id)
  for index, task in ipairs(storage.tasks) do
    if task.id == id then return index end
  end
  return nil
end

--- Generic utility to get a task by id
--- @param player LuaPlayer
--- @param id number
--- @return number, table
local function get_task_or_error(id)
  local index = find_task_index(id)
  local task = index and storage.tasks[index]
  if not task then
    -- if player then player.print("Task com ID " .. id .. " não encontrada.") end
    return nil, nil
  end
  return index, task
end

--- Generic utility to record history
--- @param task table
--- @param player_id number
--- @param field string
--- @param old_value any
--- @param new_value any
--- @return nil
local function record_history(task, player_id, field, old_value, new_value)
  task.history = task.history or {}
  table.insert(task.history, {
    field = field,
    from = old_value,
    to = new_value,
    tick = game.tick,
    player = player_id
  })
end

--- Generic utility to update a field with history
--- @param task table
--- @param field string
--- @param new_value any
--- @param player_id number
--- @param record? boolean
--- @return nil
function Tasks._update_field(task, field, new_value, player_id, record)
  local function update_map_tag()
    if (field == "title" or field == "icon") and task.show_on_map and task.location then
      if task.map_tag then
        task.map_tag.destroy()
        task.map_tag = nil
      end

      local player = game.get_player(player_id)
      if player then
        task.map_tag = player.force.add_chart_tag(player.surface, {
          position = task.location.position,
          icon = task.icon or { type = "virtual", name = "map-pin-white" },
          text = task.title
        })
      end
    end
  end

  if task[field] ~= new_value then
    if record then record_history(task, player_id, field, task[field], new_value) end
    task[field] = new_value

    update_map_tag()
  end
end

--------------------------------------------------------------------------------
-- CRUD
--------------------------------------------------------------------------------

--- Get a task by identifier
--- @param id number
--- @return table
function Tasks.get_task(id)
  for _, task in ipairs(storage.tasks) do
    if task.id == id then return task end
  end
  return nil
end

--- Get filtered tasks
--- @param params table { status: string[], assigned_id: number[], owner_id: number[] }
--- @return table
function Tasks.get_tasks(params)
  if not params then return storage.tasks end

  local result = {}
  for _, task in ipairs(storage.tasks) do
    if params.status and not TableHelper.array_contains(params.status, task.status) then goto continue end
    if params.assigned_id and not TableHelper.array_contains(params.assigned_id, task.assigned_id) then goto continue end
    if params.owner_id and not TableHelper.array_contains(params.owner_id, task.owner_id) then goto continue end

    table.insert(result, task)
    ::continue::
  end

  return result
end


--- Add a new task
--- @param player LuaPlayer
--- @param task table
--- @return nil
function Tasks.add_task(player, task)
  local task_id = generate_id()

  table.insert(storage.tasks, {
    id = task_id,
    title = task.title,
    icon = task.icon or { type = "virtual", name = "map-pin-white" },
    desc = task.desc,
    owner_id = player.index,
    status = task.status or StatusEnum.TODO,
    created_at = game.tick,
    assigned_id = task.assigned_id or nil,
    location = task.location or default_location,
    comments = {},
    history = {},
  })

  if task.subtasks then
    for _, value in pairs(task.subtasks) do
      local sub_id = Tasks.add_subtask(player, task_id, value.title)
    end
  end

  Gui.refresh_tasks()
  return task_id
end

--- Update a task
--- @param player LuaPlayer
--- @param task_id number
--- @param updated table
--- @return nil
function Tasks.update_task(player, task_id, updated)
  local index, task = get_task_or_error(task_id)
  if not task then return end

  Tasks.update_title(player, task_id, updated.title)
  Tasks.update_description(player, task_id, updated.desc)
  Tasks.update_status(player, task_id, updated.status)
  Tasks.update_icon(player, task_id, updated.icon)

  Gui.refresh_tasks()
  for k, v in pairs(updated) do
    task[k] = v
  end
end

--- Remove a task
--- @param player LuaPlayer
--- @param task_id number
--- @return nil
function Tasks.remove_task(player, task_id)
  local index = find_task_index(task_id)
  if not index then
    -- player.print("Task com ID " .. task_id .. " não encontrada.")
    return
  end
  Tasks.remove_location(player, task_id)
  local removed = table.remove(storage.tasks, index)
  Gui.refresh_tasks()
  return removed
end

--- Count tasks
--- @param params table
--- @return number
function Tasks.count_tasks(params)
  if not params or not params.status then
    return #storage.tasks
  end
  local count = 0
  for _, task in pairs(storage.tasks) do
    if task.status == params.status then
      count = count + 1
    end
  end
  return count
end

--- Add a comment to a task
--- @param player LuaPlayer
--- @param task_id number
--- @param comment_text string
--- @return nil
function Tasks.add_coments(player, task_id, comment_text)
  local index, task = get_task_or_error(task_id)
  if not task then return end

  table.insert(task.comments, {
    tick = game.tick,
    player = player.index,
    text = comment_text,
  })

  Gui.refresh_tasks()
end

--- Update a task field
--- @param player LuaPlayer
--- @param task_id number
--- @param assigned_id number
--- @return nil
function Tasks.update_assigned_id(player, task_id, assigned_id)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "assigned_id", assigned_id, player.index, true)
  Gui.refresh_tasks()
end


function Tasks.update_title(player, task_id, title)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "title", title, player.index, true)
  Gui.refresh_tasks()
end

function Tasks.update_description(player, task_id, desc)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "desc", desc, player.index, true)
  Gui.refresh_tasks()
end

--- Update a task field
--- @param player LuaPlayer
--- @param task_id number
--- @param status 'todo' | 'doing' | 'done'
--- @return nil
function Tasks.update_status(player, task_id, status)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "status", status, player.index, true)
  if status == StatusEnum.DONE then
    Tasks.update_show_on_map(player, task_id, false)
  end

  Gui.refresh_tasks()
end

--- Update a task field
--- @param player LuaPlayer
--- @param task_id number
--- @param show boolean
--- @return nil
function Tasks.update_show_on_map(player, task_id, show)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "show_on_map", show, player.index, false)

  if task and task.location then
    if show then
      task.map_tag = player.force.add_chart_tag(task.location.surface, {
        position = task.location.position,
        icon = task.icon or { type = "virtual", name = "map-pin-white" },
        text = task.title
      })
    elseif task.map_tag then
      if task.map_tag.valid then task.map_tag.destroy() end
      task.map_tag = nil
    end
  end

  Gui.refresh_tasks()
end

--- Update a task field
--- @param player LuaPlayer
--- @param task_id number
--- @param icon string
--- @return nil
function Tasks.update_icon(player, task_id, icon)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "icon", icon, player.index, false)
  Gui.refresh_tasks()
end

--- Update a task location
--- @param player LuaPlayer
--- @param task_id number
--- @param location table { position = { x = 0, y = 0 }, surface = string }
--- @return nil
function Tasks.update_location(player, task_id, location)
  local index, task = get_task_or_error(task_id)
  if not task then return end
  Tasks._update_field(task, "location", location, player.index, false)
  Gui.refresh_tasks()
end

--- Removes the location of a task and removes the map tag
--- @param player LuaPlayer
--- @param task_id number
--- @return nil
function Tasks.remove_location(player, task_id)
  local _, task = get_task_or_error(task_id)
  if not task then return end

  Tasks._update_field(task, "location", default_location, player.index, false)

  -- Remove tag from map
  if task.map_tag and task.map_tag.valid then
    task.map_tag.destroy()
    task.map_tag = default_location
  end

  Gui.refresh_tasks()
end

--- Returns the location of a task
--- @param task_id number
--- @return table
function Tasks.get_location(task_id)
  local _, task = get_task_or_error(task_id)
  if not task then return default_location end
  return task.location
end

--- Clears all tasks
--- @return nil
function Tasks.clear_tasks()
  for _, task in pairs(storage.tasks) do
    if task.map_tag and task.map_tag.valid then
      task.map_tag.destroy()
    end
  end

  storage.tasks = {}
  storage.task_id_counter = 0
  storage.subtask_id_counter = 0

  Gui.refresh_tasks()
end

--- Changes the priority of the task within its status
--- @param player LuaPlayer
--- @param task_id number
--- @param direction '"top"' | '"up"' | '"down"' | '"bottom"'
function Tasks.move_task_priority(player, task_id, direction)
  local index, task = get_task_or_error(task_id)
  if not task then return end

  local status = task.status
  local tasks = storage.tasks

  -- Filters all tasks with the same status
  local same_status_indexes = {}
  for i, t in ipairs(tasks) do
    if t.status == status then
      table.insert(same_status_indexes, i)
    end
  end

  -- Find the position of the task within the group with the same status
  local position_in_status = nil
  for pos, i in ipairs(same_status_indexes) do
    if i == index then
      position_in_status = pos
      break
    end
  end
  if not position_in_status then return end

  local new_position_in_status = position_in_status

  if direction == "top" then
    new_position_in_status = 1
  elseif direction == "up" then
    new_position_in_status = math.max(1, position_in_status - 1)
  elseif direction == "down" then
    new_position_in_status = math.min(#same_status_indexes, position_in_status + 1)
  elseif direction == "bottom" then
    new_position_in_status = #same_status_indexes
  else
    return -- direção inválida
  end

  -- Se não há mudança de posição, não faz nada
  if new_position_in_status == position_in_status then return end

  -- Remove e reinsere no local desejado
  table.remove(tasks, index)
  local new_absolute_index = same_status_indexes[new_position_in_status]

  table.insert(tasks, new_absolute_index, task)

  Gui.refresh_tasks(player)
end


--------------------------------------------------------------------------------
-- SUBTASKS
--------------------------------------------------------------------------------

--- Returns the subtasks of a task
--- @param task_id number
--- @return table
function Tasks.get_subtasks(task_id)
  local _, task = get_task_or_error(task_id)
  if not task then return {} end
  return task.subtasks or {}
end

--- Returns the subtask with the given id
--- @param task_id number
--- @param sub_id number
--- @return table
function Tasks.get_subtask(task_id, sub_id)
  local _, task = get_task_or_error(task_id)

  if not task then return nil end
  for _, st in ipairs(task.subtasks or {}) do
    if st.id == sub_id then
      return st
    end
  end
  return nil
end

--- Add a subtask to a task
--- @param player LuaPlayer
--- @param task_id number
--- @param title string
function Tasks.add_subtask(player, task_id, title)
  local _, task = get_task_or_error(task_id); if not task then return end
  task.subtasks = task.subtasks or {}
  local sub_id = generate_subtask_id(task)

  table.insert(task.subtasks, {
    id   = sub_id,
    title= title,
    done = false,
    created_at = game.tick
  })
  record_history(task, player.index, "subtasks", nil, { action = "add", id = sub_id, title = title })
  Gui.refresh_tasks()
  return sub_id
end

--- Toggle a subtask
--- @param player LuaPlayer
--- @param task_id number
--- @param sub_id number
--- @param done boolean
function Tasks.toggle_subtask(player, task_id, sub_id, done)
  local _, task = get_task_or_error(task_id); if not task then return end
  for _, st in ipairs(task.subtasks or {}) do
    if st.id == sub_id then
      local old = st
      st.done = done
      record_history(task, player.index, "subtasks", { done = not old.done }, { action = "toggle", id = sub_id, done = done })
      break
    end
  end
  Gui.refresh_tasks()
end

--- Edit a subtask
--- @param player LuaPlayer
--- @param task_id number
--- @param sub_id number
--- @param new_title string
function Tasks.edit_subtask(player, task_id, sub_id, new_title)
  local _, task = get_task_or_error(task_id); if not task then return end
  for _, st in ipairs(task.subtasks or {}) do
    if st.id == sub_id then
      local old = st
      st.title  = new_title
      record_history(task, player.index, "subtasks", { title = old.title }, { action = "edit", id = sub_id, title = new_title })
      break
    end
  end
  Gui.refresh_tasks()
end

--- Remove a subtask
--- @param player LuaPlayer
--- @param task_id number
--- @param sub_id number
function Tasks.remove_subtask(player, task_id, sub_id)
  local _, task = get_task_or_error(task_id); if not task then return end
  for i, st in ipairs(task.subtasks or {}) do
    if st.id == sub_id then
      local old = st
      table.remove(task.subtasks, i)
      record_history(task, player.index, "subtasks", { title = old.title }, { action = "remove", id = sub_id })
      break
    end
  end
  Gui.refresh_tasks()
end

--- Move uma subtarefa na lista de subtarefas da task
--- @param player LuaPlayer
--- @param task_id number
--- @param sub_id number
--- @param direction '"top"' | '"up"' | '"down"' | '"bottom"'
function Tasks.move_subtask_priority(player, task_id, sub_id, direction)
  local _, task = get_task_or_error(task_id)
  if not task or not task.subtasks then return end

  local subtasks = task.subtasks

  local current_index = nil
  for i, st in ipairs(subtasks) do
    if st.id == sub_id then
      current_index = i
      break
    end
  end
  if not current_index then return end

  local new_index = current_index

  if direction == "top" then
    new_index = 1
  elseif direction == "up" then
    new_index = math.max(1, current_index - 1)
  elseif direction == "down" then
    new_index = math.min(#subtasks, current_index + 1)
  elseif direction == "bottom" then
    new_index = #subtasks
  else
    return
  end

  if new_index == current_index then return end

  local subtask = table.remove(subtasks, current_index)

  table.insert(subtasks, new_index, subtask)

  record_history(task, player.index, "subtasks", { moved_id = sub_id, from = current_index }, { action = "move", to = new_index })

  Gui.refresh_tasks(player)
end
