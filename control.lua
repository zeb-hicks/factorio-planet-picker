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
  if DEBUG then log("Setting up storage...") end
  setup_storage()
  if DEBUG then log("Hiding Nauvis...") end
  game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)
  if DEBUG then log("Done with init.") end
end

---@param e EventData.on_runtime_mod_setting_changed
function settings_changed(e)
  for _, player in pairs(game.players) do
    GUI.rebuild(player)
  end
end

---@param e EventData.on_player_created
function player_created(e)
  if DEBUG then log("Player created") end

  local player = game.players[e.player_index]
  local character = player.character
  local items = collect_items_from(player)

  setup_storage()
  storage.inventories[player.index] = items

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

---@param e EventData.on_console_chat
function chat(e)
  -- Exit early if the chat setting is disabled.
  if not settings.global["planet-picker-chat"].value then return end

  if e.player_index == nil then return end
  ---@type LuaPlayer
  local player = game.players[e.player_index]
  if player == nil then return end

  -- This player is still picking a planet.
  local player_picking = player.force.name == "picking_planet"

  for _, other in pairs(game.players) do
    -- This player is the same as the one who sent the message.
    local same_player = player.name == other.name
    -- The other player is picking their planet.
    local other_picking = other.force.name == "picking_planet"
    -- The setting to speak to other players in the picker is enabled.
    local see_other_chats = settings.global["planet-picker-chat-see-other-forces"].value == true
    -- The setting to see messages from other players that have already picked is enabled.
    local speak_to_others = settings.global["planet-picker-chat-speak-other-forces"].value == true

    if player_picking then
      -- Send message from a player in the picker to other players, if the setting is enabled.
      if not same_player and not other_picking and speak_to_others then
        other.print(player.name .. " (" .. human_readable_name(player.force.name) .. "): " .. e.message)
      end
    else
      -- Send message to a player in the picker from any other player, if the setting is enabled.
      if not same_player and other_picking and see_other_chats then
        local location = "Unknown Location"
        if player.surface.planet ~= nil then
          location = human_readable_name(player.surface.planet.name)
        elseif player.surface.name ~= nil then
          location = human_readable_name(player.surface.name)
        end
        other.print(player.name .. " (" .. human_readable_name(player.force.name) .. " on " .. location .. "): " .. e.message)
      end
    end
  end
end

script.on_init(init)
script.on_event(defines.events.on_tick, tick)
script.on_event(defines.events.on_player_created, player_created)
script.on_event(defines.events.on_runtime_mod_setting_changed, settings_changed)
script.on_event(defines.events.on_research_finished, research_finished)
script.on_event(defines.events.on_console_chat, chat)
