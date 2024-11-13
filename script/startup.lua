function chart_starting_area(surface)
  local r = storage.chart_distance or 200
  local force = game.forces.player
  local origin = force.get_spawn_position(surface)
  force.chart(surface, {{origin.x - r, origin.y - r}, {origin.x + r, origin.y + r}})
  -- force.chart_all(surface)
end
