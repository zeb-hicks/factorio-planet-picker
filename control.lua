require("gui/planet-select")
require("script/startup")
require("script/planet-select")

function init()
  game.create_force("picking_planet")
  create_empty_void()
  game.forces.player.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.nauvis, true)
  game.forces.picking_planet.disable_research()
  game.forces.picking_planet.disable_all_prototypes()

  game.planets.gleba.create_surface()
  game.planets.fulgora.create_surface()
  game.planets.vulcanus.create_surface()
  game.planets.aquilo.create_surface()

  game.surfaces.gleba.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.fulgora.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.vulcanus.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.aquilo.request_to_generate_chunks({0, 0}, 8)

  if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    remote.call("freeplay", "set_ship_items", {})
    remote.call("freeplay", "set_debris_items", {})
  end

  chart_starting_area(game.planets.gleba.surface)
  chart_starting_area(game.planets.fulgora.surface)
  chart_starting_area(game.planets.vulcanus.surface)
  chart_starting_area(game.planets.aquilo.surface)
end

---@param player LuaPlayer
function collect_items_from(player)
  local items = {}
  if not player then return items end

  local main = player.get_inventory(defines.inventory.character_main)
  local guns = player.get_inventory(defines.inventory.character_guns)
  local ammo = player.get_inventory(defines.inventory.character_ammo)
  local armor = player.get_inventory(defines.inventory.character_armor)
  local trash = player.get_inventory(defines.inventory.character_trash)

  if main then for _, item in pairs(main and main.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_main }) end end
  if guns then for _, item in pairs(guns and guns.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_guns }) end end
  if ammo then for _, item in pairs(ammo and ammo.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_ammo }) end end
  if armor then for _, item in pairs(armor and armor.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_armor }) end end
  if trash then for _, item in pairs(trash and trash.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_trash }) end end

  return items
end

function ensure_setup()
  if not game.forces["picking_planet"] then init() end
end

function player_created(e)
  ensure_setup()

  local player = game.players[e.player_index]
  local character = player.character
  local items = collect_items_from(player)
  storage.inventories = storage.inventories or {}
  storage.inventories[player.index] = items

  if character then character.destroy() end

  player.force = game.forces.picking_planet

  player.set_controller({type = defines.controllers.spectator})
  player.teleport({0, 0}, game.surfaces.empty_void)
  player.minimap_enabled = false

  GUI.make_startup_window(player)
end

function tick(e)
  for _, player in pairs(game.players) do
    local surface = player.surface
    if surface.name == "empty_void" then
      player.teleport({
        math.cos(game.tick / 1250) * 60,
        math.sin(game.tick / 1250) * 60
      })
      player.zoom = 2
    end
  end
end

script.on_event(defines.events.on_game_created_from_scenario, init)
script.on_event(defines.events.on_tick, tick)
script.on_event(defines.events.on_player_created, player_created)
