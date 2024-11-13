require("gui")
require("script/startup")
require("script/planet-select")
require("script/thermal-vent")

function init()
  if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    remote.call("freeplay", "set_ship_items", {})
    remote.call("freeplay", "set_debris_items", {})
  end

  PlanetSelect.setup_force()
  PlanetSelect.setup_planets()
end

---@param e EventData.on_runtime_mod_setting_changed
function settings_changed(e)
  GUI.update(game.players[e.player_index], PlanetSelect.planets)
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

  GUI.setup(PlanetSelect.planets)
  -- GUI.make_startup_window(player)
  GUI.spawn_loading_screen(player)
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

remote.add_interface("planet-picker", {
  add_planet = PlanetSelect.add_planet
})

script.on_event(defines.events.on_game_created_from_scenario, init)
script.on_event(defines.events.on_tick, tick)
script.on_event(defines.events.on_player_created, player_created)
script.on_event(defines.events.on_runtime_mod_setting_changed, settings_changed)