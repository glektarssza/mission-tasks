TableHelper = {}

--- Shallow copy of a table
--- @param tbl table
--- @return table
function TableHelper.shallow_copy(tbl)
  local copy = {}
  for k, v in pairs(tbl) do
    copy[k] = v
  end
  return copy
end

--- Checks if a value exists in an array (including nils)
--- @param array table
--- @param values table
--- @return boolean
function TableHelper.array_contains(array, values)
  if values == nil then
    for _, v in pairs(array) do
      if v == "nil" then
        return true
      end
    end
    return false
  end

  for _, v in pairs(array) do
    if v == values then
      return true
    end
  end

  return false
end

--- Combina duas listas em uma nova tabela
--- @param t1 table
--- @param t2 table
--- @return table
function TableHelper.merge(t1, t2)
  local result = {}

  -- Copia os elementos do primeiro array
  for _, v in ipairs(t1) do
    table.insert(result, v)
  end

  -- Copia os elementos do segundo array
  for _, v in ipairs(t2) do
    table.insert(result, v)
  end

  return result
end
