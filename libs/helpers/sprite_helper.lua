SpriteHelper = {}

function SpriteHelper.icon_to_sprite(icon)
  if not icon then
    return "virtual-signal/map-pin-white"
  end
  if type(icon) == "string" then
    return icon
  end

  if icon.type == "virtual" then
    return "virtual-signal/" .. icon.name
  elseif icon.type == "item" then
    return "item/" .. icon.name
  elseif icon.type == "fluid" then
    return "fluid/" .. icon.name
  elseif icon.type == "entity" then
    return "entity/" .. icon.name
  else
    -- fallback seguro
    return "virtual-signal/map-pin-white"
  end
end

function SpriteHelper.icon_rich_text(icon)
  if not icon or not icon.name then
    return "[img=virtual-signal/map-pin-white] "
  end

  local type_map = {
    ["virtual"] = "virtual-signal",
    ["item"] = "item",
    ["fluid"] = "fluid",
    ["entity"] = "entity",
    ["technology"] = "technology",
    ["recipe"] = "recipe",
    ["space-location"] = "space-location",
  }
  if icon.type then
    local icon_type = type_map[icon.type or "virtual"] or "virtual-signal"
    return string.format("[img=%s/%s]", icon_type, icon.name)
  end

  return string.format("[img=%s/%s]", "item", icon.name)
end

function SpriteHelper.location_to_rich_text(location)
  if not location or not location.position or not location.surface then
    return "[img=space-location/nauvis]"
  end
  local surface = location.surface
  local type = "space-location"
  local name = StringHelper.capitalize(location.surface) or "Unknown"

  if location.surface:match("^platform%-(%d+)$") then
    surface = "space-platform-starter-pack"
    type = "item"
    name = "Platform "

    for _, surface in pairs(game.surfaces) do
      if surface.name == location.surface then
        name = surface.platform.name
      end
    end
  end


  return string.format("[img=%s/%s] %s", type, surface, name)
end
