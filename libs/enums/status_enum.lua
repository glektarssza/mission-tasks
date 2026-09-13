StatusEnum = {
  TODO  = "todo",
  DOING = "doing",
  DONE  = "done",

  values = { "todo", "doing", "done" },
  external_values = {
    {"enum.status-todo-value"},
    {"enum.status-doing-value"},
    {"enum.status-done-value"},
  },
  index_map = {
    ["todo"]  = 1,
    ["doing"] = 2,
    ["done"]  = 3,
  },
}

function StatusEnum.value_from_index(index)
  return StatusEnum.values[index]
end

function StatusEnum.index_from_value(value)
  return StatusEnum.index_map[value] or 1
end
