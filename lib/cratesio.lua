local M = {}

function M:to_cargo_path(crate_name)
  if #crate_name == 0 then
    return nil, "Crate name cannot be empty"
  elseif #crate_name == 1 then
    return ("1/%s"):format(crate_name), nil
  elseif #crate_name == 2 then
    return ("2/%s"):format(crate_name), nil
  elseif #crate_name == 3 then
    local first_char = crate_name:sub(1, 1)
    return ("3/%s/%s"):format(first_char, crate_name), nil
  else
    local first_two = crate_name:sub(1, 2)
    local next_two = crate_name:sub(3, 4)
    return ("%s/%s/%s"):format(first_two, next_two, crate_name), nil
  end
end

return M
