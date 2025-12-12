-- metadata.lua
-- Backend plugin metadata and configuration
-- Documentation: https://mise.jdx.dev/backend-plugin-development.html

PLUGIN = { -- luacheck: ignore
  -- Required: Plugin name (will be the backend name users reference)
  name = "cargo-quickinstall",

  -- Required: Plugin version (not the tool versions)
  version = "1.0.0",

  -- Required: Brief description of the backend and tools it manages
  description = "A mise backend plugin for using cargo-quickinstall's prebuilt binaries",

  -- Required: Plugin author/maintainer
  author = "sevenc-nanashi",

  -- Optional: Plugin homepage/repository URL
  homepage = "https://github.com/sevenc-nanashi/mise-cargo-quickinstall",

  -- Optional: Plugin license
  license = "MIT",

  -- Optional: Important notes for users
  notes = {
    "Requires curl and tar to download and extract binaries",
    "Recommended to install rustc",
    -- "This plugin manages tools from the <BACKEND> ecosystem"
  },
}
