function PLUGIN:BackendExecEnv(ctx)
  local install_path = ctx.install_path
  -- local tool = ctx.tool
  -- local version = ctx.version

  local file = require("file")
  local bin_path = file.join_path(install_path, "bin")

  local env_vars = {
    { key = "PATH", value = bin_path },
  }

  return {
    env_vars = env_vars,
  }
end
