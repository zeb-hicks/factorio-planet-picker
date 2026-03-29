for _, force in pairs(game.forces) do
  ---@type LuaTechnology
  local fluid_handling = force.technologies["fluid-handling"]
  local found = find_in(fluid_handling.prerequisites, "ice-melting")
  if not found and fluid_handling.researched then
    force.recipes["ice-melting"].enabled = true
  end
end
