local http = require("http")
local json = require("json")
local index = require("../lib/index")

function PLUGIN:BackendListVersions(ctx)
  local tool = ctx.tool

  -- Validate tool name
  if not tool or tool == "" then
    error("Tool name cannot be empty")
  end

  local data = index.fetch_index()
  if not data[tool] then
    error("Tool not found: " .. tool)
  end

  local versions = {}
  local targets = index.available_targets()
  if data[tool] then
    for version in pairs(data[tool]) do
      for _, want_target in ipairs(targets) do
        if data[tool][version]["assets"][want_target] then
          table.insert(versions, data[tool][version]["version"])
          break
        end
      end
    end
  end

  if #versions == 0 then
    error("No versions found for " .. tool)
  end

  table.sort(versions, function(a, b)
    for _i = 1, math.max(#a, #b) do
      local a_part = tonumber(a:match("^(%d+)") or "0")
      local b_part = tonumber(b:match("^(%d+)") or "0")
      if a_part ~= b_part then
        return a_part < b_part
      end
      a = a:sub(#tostring(a_part) + 2)
      b = b:sub(#tostring(b_part) + 2)
    end
    return false
  end)

  return { versions = versions }
end
