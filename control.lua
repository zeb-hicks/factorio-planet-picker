require("gui")
require("utils")
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
  GUI.spawn_loading_screen(player)
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

remote.add_interface("planet-picker", {
  add_planet = PlanetSelect.add_planet
})

---@param e EventData.on_research_finished
function research_finished(e)
  if e.research.name == "biochamber" then
    e.research.force.technologies["landfill"].researched = true
  end
  if e.research.name == "calcite-trigger" then
    e.research.force.technologies["calcite-processing"].researched = true
    e.research.force.technologies["calcite-trigger"].enabled = false
  end
  if e.research.name == "calcite-processing" then
    e.research.force.technologies["calcite-trigger"].researched = true
    e.research.force.technologies["calcite-trigger"].enabled = false
  end
end

script.on_event(defines.events.on_game_created_from_scenario, init)
script.on_event(defines.events.on_tick, tick)
script.on_event(defines.events.on_player_created, player_created)
script.on_event(defines.events.on_runtime_mod_setting_changed, settings_changed)
script.on_event(defines.events.on_research_finished, research_finished)