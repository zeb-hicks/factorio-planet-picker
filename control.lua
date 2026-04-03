require("gui")
require("utils")
require("script/startup")
require("script/planet-select")
require("script/thermal-vent")

DEBUG = false

if script.active_mods["debugadapter"] then
  DEBUG = true
  log("Detected debug adapter, enabling debug mode.")
end

function init()
  if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    remote.call("freeplay", "set_ship_items", {})
    remote.call("freeplay", "set_debris_items", {})
  end

  if DEBUG then log("Setting up PlanetSelect") end
  PlanetSelect.setup_force()
  if DEBUG then log("Hiding Nauvis...") end
  game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)
  if DEBUG then log("Done with init.") end
end

---@param e EventData.on_runtime_mod_setting_changed
function settings_changed(e)
  if DEBUG then log("Settings changed") end;
  if e.player_index ~= nil then
    GUI.rebuild(game.players[e.player_index])
  end
end

---@param e EventData.on_player_created
function player_created(e)
  if DEBUG then log("Player created") end

  local player = game.players[e.player_index]
  local character = player.character
  local items = collect_items_from(player)
  storage.inventories = storage.inventories or {}
  storage.inventories[player.index] = items

  storage.ui = storage.ui or {}
  storage.ui[e.player_index] = {
    selected_planet = "nauvis"
  }
  if DEBUG then log("Created player ui store:") end
  if DEBUG then log(serpent.block(storage.ui[e.player_index])) end

  if character then character.destroy() end

  player.force = game.forces.picking_planet

  player.set_controller({ type = defines.controllers.spectator })
  player.teleport({ 0, 0 }, game.surfaces.empty_void)
  player.minimap_enabled = false

  if DEBUG then log("Player creation GUI setup") end
  GUI.make_startup_window(player)
  if DEBUG then log("Player creation done") end
end

---@param e EventData.on_tick
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

script.on_init(init)
-- script.on_event(defines.events.on_game_created_from_scenario, init)
script.on_event(defines.events.on_tick, tick)
script.on_event(defines.events.on_player_created, player_created)
-- script.on_event(defines.events.on_player_joined_game, player_joined)
script.on_event(defines.events.on_runtime_mod_setting_changed, settings_changed)
script.on_event(defines.events.on_research_finished, research_finished)
