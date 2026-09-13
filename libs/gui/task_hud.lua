TaskHud = {}

function TaskHud.draw(player)
  local cfg = Settings.get(player.index)

  TaskHud.destroy(player)

  if not cfg.show_tasks_hud then return end


  local font_size = Settings.get(player.index).font_size

  local function draw_caption(parent, caption, color, sprite)
    local flow = parent.add {
      type = "flow",
      direction = "horizontal"
    }
    flow.style.vertical_align = "center"

    if (sprite) then
      flow.add {
        type = "sprite",
        sprite = sprite,
        resize_to_sprite = false
      }.style.size = 14
    end

    local caption_label = flow.add {
      type = "label",
      caption = caption,
    }
    caption_label.style.font_color = color or { r = 255, g = 255, b = 255 }

    local function get_bold_font_by_size(size)
      if size == FontSizeEnum.SMALL then
        return "default-small"
      else
        return "default-bold"
      end
    end

    caption_label.style.font = get_bold_font_by_size(font_size)
  end

  local function print_tasks(parent, tasks, caption, caption_color, sprite)
    if #tasks == 0 then return end

    draw_caption(parent, caption, caption_color, sprite)

    if not tasks or #tasks == 0 then return end
    for _, task in pairs(tasks) do
      if task.assigned_id ~= player.index and task.assigned_id ~= -1 then goto continue_b end

      local task_group = parent.add {
        type = "flow",
        direction = "vertical",
      }

      -- tasks title
      local task_row = task_group.add {
        type = "flow",
        direction = "horizontal",
      }
      task_row.style.left_margin = 8
      task_row.style.vertical_align = "center"
      task_row.style.horizontally_stretchable = true

      if task.assigned_id == -1 then --global task
        task_row.add {
          type = "sprite",
          sprite = "mission-tasks-earth-white-icon",
          resize_to_sprite = false
        }.style.size = 16
      else
        task_row.add {
          type = "sprite",
          sprite = "mission-tasks-chevrons-right-white-icon",
          resize_to_sprite = false
        }.style.size = 16
      end

      local label = task_row.add {
        type = "label",
        caption = task.title or "Sem título"
      }
      label.style.font = "default" .. (font_size == FontSizeEnum.MEDIUM and "" or ("-" .. font_size) or "-small")
      label.style.single_line = false

      -- subtasks
      if not cfg.show_subtasks_hud
        or not task.subtasks
        or #task.subtasks == 0
      then goto continue_b end

      for _, subtask in pairs(task.subtasks) do
        if subtask.done and not cfg.show_completed_subtasks_hud then goto continue_a end

        local subtask_row = task_group.add {
          type = "flow",
          direction = "horizontal"
        }
        subtask_row.style.left_margin = 16
        subtask_row.style.vertical_align = "center"

        subtask_row.add {
          type = "sprite",
          sprite = subtask.done and "mission-tasks-square-checked-white-icon" or "mission-tasks-square-white-icon",
          resize_to_sprite = false
        }.style.size = 16

        local subtask_label = subtask_row.add {
          type = "label",
          caption = subtask.title or "Sem título"
        }
        subtask_label.style.font = "default" .. (font_size == FontSizeEnum.MEDIUM and "" or ("-" .. font_size) or "-small")
        subtask_label.style.single_line = false

        ::continue_a::
      end
      ::continue_b::
    end
  end

  local container = player.gui.left.add {
    type = "frame",
    direction = "vertical",
    name = "mission-tasks-task-hud",
    ignored_by_interaction = true,
    style = "mission_tasks_translucent_" .. (cfg.hud_opacity or "0"),
  }
  container.style.maximal_width = 300
  container.style.vertically_stretchable = false

  local unassigned_tasks = Tasks.get_tasks({
    status = { "todo", "doing" },
    assigned_id = { "nil" }
  })

  if #unassigned_tasks > 0 then
    draw_caption(container, {"mission-tasks.warning-tasks-without-assignee-caption", #unassigned_tasks or 0})
  end

  if cfg.show_doing_tasks_hud then
    local doing_tasks = Tasks.get_tasks({ assigned_id = { player.index, -1 }, status = { "doing" } })
    if #doing_tasks > 0 then
      print_tasks(
        container,
        doing_tasks,
        StatusEnum.external_values[2],
        { r = 0, g = 150, b = 255 },
        "mission-tasks-hammer-blue-icon"
      )
    end
  end

  if cfg.show_todo_tasks_hud then
    local todo_tasks = Tasks.get_tasks({ assigned_id = { player.index, -1 }, status = { "todo" } })
    if #todo_tasks > 0 then
      print_tasks(
        container,
        todo_tasks,
        StatusEnum.external_values[1],
        { r = 255, g = 255, b = 50 },
        "mission-tasks-flag-yellow-black-icon"
      )
    end
  end

  if cfg.show_done_tasks_hud then
    local done_tasks = Tasks.get_tasks({ assigned_id = { player.index, -1 }, status = { "done" } })
    if #done_tasks > 0 then
      print_tasks(
        container,
        done_tasks,
        StatusEnum.external_values[3],
        { r = 0, g = 255, b = 0 },
        "mission-tasks-circle-checked-green-icon"
      )
    end
  end
end

function TaskHud.destroy(player)
  if player.gui.left["mission-tasks-task-hud"] then
    player.gui.left["mission-tasks-task-hud"].destroy()
  end
end

--- Redraws the task HUD
--- @param player? LuaPlayer
function TaskHud.redraw(player)
  if not player then
    for _, player in pairs(game.players) do
      TaskHud.destroy(player)
      TaskHud.draw(player)
    end
  else
    TaskHud.destroy(player)
    TaskHud.draw(player)
  end
end
