local function create_translucent_style(name, opacity)
  data.raw["gui-style"].default[name] = {
    type = "frame_style",
    parent = "frame",
    padding = 8,
    graphical_set = {
      type = "composition",
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      corner_size = {3, 3},
      position = {0, 0},
      opacity = opacity
    }
  }
end

create_translucent_style("mission_tasks_translucent_0",   0.0)
create_translucent_style("mission_tasks_translucent_10",  0.1)
create_translucent_style("mission_tasks_translucent_20",  0.2)
create_translucent_style("mission_tasks_translucent_30",  0.3)
create_translucent_style("mission_tasks_translucent_40",  0.4)
create_translucent_style("mission_tasks_translucent_50",  0.5)
create_translucent_style("mission_tasks_translucent_60",  0.6)
create_translucent_style("mission_tasks_translucent_70",  0.7)
create_translucent_style("mission_tasks_translucent_80",  0.8)
create_translucent_style("mission_tasks_translucent_90",  0.9)
create_translucent_style("mission_tasks_translucent_100", 1.0)
