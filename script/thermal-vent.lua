function entity_built(e)
  local entity = e.entity
  if entity.name == "thermal-vent" then
    dlog("Thermal vent generator built")
    entity.surface.create_entity({name = "thermal-vent-generator", position = entity.position, force = entity.force})
  end
end

function entity_destroyed(e)
  local entity = e.entity
  if entity.name == "thermal-vent" then
    ---@type LuaEntity
    local generator = entity.surface.find_entity("thermal-vent-generator", entity.position)
    if generator then generator.destroy({raise_destroy = false}) end
  end
  if entity.name == "thermal-vent-generator" then
    ---@type LuaEntity
    local vent = entity.surface.find_entity("thermal-vent", entity.position)
    if vent then vent.destroy({raise_destroy = false}) end
  end
end

if settings.startup["planet-picker-modify-vulcanus-generator"] then

  script.on_event(defines.events.on_built_entity, entity_built)
  script.on_event(defines.events.on_robot_built_entity, entity_built)
  script.on_event(defines.events.script_raised_built, entity_built)

  script.on_event(defines.events.on_player_mined_entity, entity_destroyed)
  script.on_event(defines.events.on_robot_mined_entity, entity_destroyed)
  script.on_event(defines.events.on_entity_died, entity_destroyed)
  script.on_event(defines.events.script_raised_destroy, entity_destroyed)

end
