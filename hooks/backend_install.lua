local http = require("http")
local os = require("os")
local archiver = require("archiver")


local index = require("../lib/index")

function PLUGIN:BackendInstall(ctx)
  local tool = ctx.tool
  local version = ctx.version
  local install_path = ctx.install_path

  -- Validate inputs
  if not tool or tool == "" then
    error("Tool name cannot be empty")
  end
  if not version or version == "" then
    error("Version cannot be empty")
  end
  if not install_path or install_path == "" then
    error("Install path cannot be empty")
  end

  local data = index.fetch_index()
  if not data[tool] then
    error("Tool not found: " .. tool)
  end
  local version_index = nil
  for i, v in pairs(data[tool]) do
    if v["version"] == version then
      version_index = i
      break
    end
  end
  if not version_index then
    -- TODO: check crates.io, and it exists there, send the stat to cargo-quickinstall so that it can be added to the index
    error("Version " .. version .. " not found for tool " .. tool)
  end

  local version_info = data[tool][version_index]
  if not version_info then
    error("Unreachable: version info missing for " .. tool .. "@" .. version)
  end
  local assets = version_info["assets"]
  if not assets then
    error("No assets found for " .. tool .. "@" .. version)
  end

  local targets = index.available_targets()
  local selected_asset = nil
  for _, target in ipairs(targets) do
    if assets[target] then
      selected_asset = assets[target]
      break
    end
  end
  if not selected_asset then
    -- TODO: check crates.io, and it exists there, send the stat to cargo-quickinstall so that it can be added to the index
    error("No compatible asset found for " .. tool .. "@" .. version .. " on this platform")
  end


  local temp_file = install_path .. "/binary.tar.gz"
  local _resp, err = http.download_file({
    url = selected_asset.url,
  }, temp_file)

  if err then
    error("Failed to download " .. tool .. "@" .. version .. ": " .. err)
  end

  local binary_path = install_path .. "/bin"
  err = archiver.decompress(
    temp_file,
    binary_path
  )
  if err then
    error("Failed to extract " .. tool .. "@" .. version .. ": " .. err)
  end

  -- Clean up temp file
  os.remove(temp_file)

  return {}
end
