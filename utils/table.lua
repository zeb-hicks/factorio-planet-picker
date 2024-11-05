---@param target table?
---@param values table?
---@return table?
function copy_to(target, values)
  if (target == nil) then return values or nil end
  if (values == nil) then return target end
  for k, v in pairs(values) do
    target[k] = v
  end
  return target
end