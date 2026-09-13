ExpImpHelper = {}
local base64 = require("libs.base64")

function ExpImpHelper.export()
  local serialized = serpent.block(storage.tasks or {}, { comment = false })
  local encoded = base64.encode(serialized)

  return encoded
end

function ExpImpHelper.import(data)
  local decoded = base64.decode(data)
  local ok, deserialized = serpent.load(decoded)

  return deserialized
end
