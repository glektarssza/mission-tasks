data:extend({
  {
    type = "selection-tool",
    name = "task-location-selector",
    -- icon = "__mission-tasks-2_1__/graphics/icons/map_white.png",
    -- icon_size = 24,
    icons = {
      {
        icon = "__mission-tasks-2_1__/graphics/sprites/location_selector.png",
        icon_size = 64,
        scale = 0.5
      }
    },
    flags = {"only-in-cursor", "spawnable", "not-stackable"},
    subgroup = "tool",
    order = "c[automated-construction]-a[task-location-selector]",
    stack_size = 1,

    select = {
      mode = "any-entity",
      cursor_box_type = "entity",
      border_color = { r = 0, g = 1, b = 0 },
    },
    alt_select = {
      mode = "any-entity",
      cursor_box_type = "entity",
      border_color = { r = 1, g = 0, b = 0 },
    },
  }
})
