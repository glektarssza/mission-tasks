DebugHelper = {
  debug_mode = true
}

--- Dumps a table
--- @param tbl table
function DebugHelper.dump(table)
  game.print(serpent.block(table))
end

function DebugHelper.logger(msg)
  if not debug_mode then return end
  game.print(msg)
end
