local M = {}

local http = require("http")
local json = require("json")
function M:fetch_index()
  -- TODO: cache the index locally to avoid repeated network calls
  local api_url =
  "https://raw.githubusercontent.com/sevenc-nanashi/mise-cargo-quickinstall/refs/heads/main/index.generated.json"

  local resp, err = http.get({
    url = api_url,
  })

  if err then
    error("Failed to fetch index from API: " .. err)
  end

  if resp.status_code ~= 200 then
    error("API returned status " .. resp.status_code)
  end

  local data = json.decode(resp.body)
  return data
end

function M:available_targets()
  if RUNTIME.osType == "windows" then
    if RUNTIME.archType == "amd64" then
      return { "x86_64-pc-windows-msvc" }
    elseif RUNTIME.archType == "arm64" then
      return { "aarch64-pc-windows-msvc" }
    end
  elseif RUNTIME.osType == "linux" then
    -- TODO: allow user to choose between gnu and musl
    if RUNTIME.archType == "amd64" then
      return { "x86_64-unknown-linux-gnu", "x86_64-unknown-linux-musl" }
    elseif RUNTIME.archType == "arm64" then
      return { "aarch64-unknown-linux-gnu", "aarch64-unknown-linux-musl" }
    elseif RUNTIME.archType == "armv7l" then
      return { "armv7-unknown-linux-gnueabihf", "armv7-unknown-linux-musleabihf" }
    end
  elseif RUNTIME.osType == "darwin" then
    if RUNTIME.archType == "amd64" then
      return { "x86_64-apple-darwin" }
    elseif RUNTIME.archType == "arm64" then
      return { "aarch64-apple-darwin" }
    end
  end
  return {}
end

return M
