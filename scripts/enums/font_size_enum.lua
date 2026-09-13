FontSizeEnum = {
  SMALL  = "small",
  MEDIUM = "medium",
  LARGE  = "large",

  values = { "small", "medium", "large" },
  external_values = {
    {"enum.font-size-small-value"},
    {"enum.font-size-medium-value"},
    {"enum.font-size-large-value"},
  },
  index_map = {
    ["small"]  = 1,
    ["medium"] = 2,
    ["large"]  = 3,
  },
}

function FontSizeEnum.value_from_index(index)
  return FontSizeEnum.values[index]
end

function FontSizeEnum.index_from_value(value)
  return FontSizeEnum.index_map[value] or 1
end
