for _, force in pairs(game.forces) do
  log("Migrating force "..force.name)
  ---@type LuaTechnology
  local fluid_handling = force.technologies["fluid-handling"]
  local found = find_in(fluid_handling.prerequisites, "ice-melting")
  log(serpent.block(fluid_handling.prerequisites))
  if not found and fluid_handling.researched then
    log("Migration adding ice melting to fluid handling technology.")
    force.recipes["ice-melting"].enabled = true
  end
end
