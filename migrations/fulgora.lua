for _, force in pairs(game.forces) do
  dlog("Migrating force "..force.name)
  ---@type LuaTechnology
  local fluid_handling = force.technologies["fluid-handling"]
  local found = find_in(fluid_handling.prerequisites, "ice-melting")
  dlog(serpent.block(fluid_handling.prerequisites))
  if not found and fluid_handling.researched then
    dlog("Migration adding ice melting to fluid handling technology.")
    force.recipes["ice-melting"].enabled = true
  end
end
