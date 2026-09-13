--- Returns a formatted string with the elapsed time since a past tick.
--- @param past_tick integer
--- @return table Localized string table
function FormatElapsedTime(past_tick)
  if not past_tick then
    return {"time.elapsed-time-unknown"}
  end

  local ticks_passed = game.tick - past_tick
  if ticks_passed < 0 then
    return {"time.elapsed-time-error"}
  end

  local total_seconds = math.floor(ticks_passed / 60)

  local days = math.floor(total_seconds / 86400)      -- 60*60*24
  local hours = math.floor((total_seconds % 86400) / 3600)
  local minutes = math.floor((total_seconds % 3600) / 60)
  local seconds = total_seconds % 60

  if days > 0 then
    return {"time.elapsed-time-days", days}
  elseif hours > 0 then
    return {"time.elapsed-time-hours", hours}
  elseif minutes > 0 then
    return {"time.elapsed-time-minutes", minutes}
  else
    return {"time.elapsed-time-seconds", seconds}
  end
end
