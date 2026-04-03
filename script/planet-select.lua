require("utils")

---@class PlanetSelect
---@field planets  PlanetSelectorDefinition[]
---@field api_planets  PlanetSelectorDefinition[]
---@field vanilla_planets  PlanetSelectorDefinition[]
---@field add_planet  function
---@field create_empty_void  function
---@field enable_planet  function
---@field reload_planets  function
---@field setup_force  function
---@field start_on  function
PlanetSelect = PlanetSelect or {}
PlanetSelect.planets = PlanetSelect.planets or {}

PlanetSelect.start_on = function(planet, player)
  local force = game.forces.player;
  player.force = force
  player.minimap_enabled = true

  local surface = game.surfaces[planet]
  if surface == nil then return end

  local position = surface.find_non_colliding_position("character", force.get_spawn_position(surface),
    surface.get_starting_area_radius(), 2)
  if position == nil then return end

  unlock_planet_technology(force, surface)

  if DEBUG then log("Starting on " .. planet) end
  local planet_data = find_in(PlanetSelect.planets, { name = planet })
  if planet_data ~= nil then
    if DEBUG then log("Planet data found for " .. planet) end
    planet_data = PlanetSelect.planets[planet_data]
    if DEBUG then log(serpent.block(planet_data)) end
    if planet_data.callback then planet_data.callback(player, planet_data.first) end
    if planet_data.remote then
      remote.call(planet_data.remote.interface, planet_data.remote.fn, player, planet_data.first)
    end
    planet_data.first = false
  end

  player.teleport(position, surface)

  local character = surface.create_entity({ name = "character", position = position or { 0, 0 }, force = force })
  player.set_controller({ type = defines.controllers.character, character = character })
  storage.inventories = storage.inventories or {}
  if storage.inventories[player.index] == nil then
    local items = collect_items_from(player)
    storage.inventories[player.index] = items
  end
  for _, item in pairs(storage.inventories[player.index]) do
    player.get_inventory(item.inventory).insert(item.item)
  end
end

PlanetSelect.create_empty_void = function()
  local surface = game.create_surface("empty_void", {
    seed = 0,
    width = 250,
    height = 250,
    no_enemies_mode = true,
    peaceful_mode = true,
    starting_area = "none",
    autoplace_controls = {},
    default_enable_all_autoplace_controls = false,
    water = "none",
    cliff_settings = { cliff_elevation_0 = 0, cliff_elevation_interval = 0, name = "cliff", richness = 0, control = "cliff", cliff_smoothing = 0 },
    starting_points = { { x = 0, y = 0 } },
    territory_settings = {
      units = { "" },
      territory_variation_expression = "",
      minimum_territory_size = 0,
      territory_index_expression = ""
    },
    autoplace_settings = {},
    property_expression_names = {},
  })
  -- surface.generate_with_lab_tiles = true
  for x = -125, 125 do
    for y = -125, 125 do
      surface.set_tiles({ { position = { x, y }, name = "empty-space" } })
    end
  end
end

PlanetSelect.setup_force = function()
  game.create_force("picking_planet")

  PlanetSelect.create_empty_void()
  game.forces.player.set_surface_hidden(game.surfaces.empty_void, true)
  for _, surface in pairs(game.surfaces) do
    game.forces.player.set_surface_hidden(surface, true)
    game.forces.picking_planet.set_surface_hidden(surface, true)
  end
  game.forces.picking_planet.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.nauvis, true)
  game.forces.picking_planet.disable_research()
  game.forces.picking_planet.disable_all_prototypes()
end

---@param player LuaPlayer
---@param first boolean
function vulcanus_setup(player, first)
  for _, force in pairs(game.forces) do
    if DEBUG then log("Unlocking acid processing for " .. force.name .. " force") end
    force.technologies["acid-processing"].enabled = true
  end
end

---@class PlanetSelectorRemoteCallback
---@field interface string Remote interface name to be called
---@field fn string Function on the remote interface to call when a player starts on this planet

---@class PlanetSelectorDefinition
---@field name string Planet Name
---@field tooltip string|nil Tooltip shown on hover
---@field icon string|nil Icon sprite name
---@field surface string Planet surface name
---@field first boolean|nil Whether the next player to drop here will be the first
---@field callback function|nil Function called when a player starts on this planet
---@field remote PlanetSelectorRemoteCallback|nil
---@field auto boolean|nil Whether this planet was auto-generated from a prototype

---@type PlanetSelectorDefinition[]
PlanetSelect.vanilla_planets = {
  { name = "nauvis",   tooltip = "Nauvis",   icon = "nauvis",   surface = "nauvis",   first = true },
  { name = "gleba",    tooltip = "Gleba",    icon = "gleba",    surface = "gleba",    first = true },
  { name = "fulgora",  tooltip = "Fulgora",  icon = "fulgora",  surface = "fulgora",  first = true },
  { name = "vulcanus", tooltip = "Vulcanus", icon = "vulcanus", surface = "vulcanus", first = true, callback = vulcanus_setup },
  { name = "aquilo",   tooltip = "Aquilo",   icon = "aquilo",   surface = "aquilo",   first = true },
}

---@type PlanetSelectorDefinition[]
PlanetSelect.api_planets = {}

---@param options PlanetSelectorDefinition
PlanetSelect.add_planet = function(options)
  if not options or type(options) ~= "table" then error("add_planet expects a table of options defining the new planet") end
  if not options.name then error("add_planet requires a name parameter") end
  if blacklisted(options.name) then return end
  if not options.surface then error("add_planet requires a surface parameter") end
  local exists = find_in(PlanetSelect.planets, { name = options.name })
  if exists then
    if DEBUG then log("Planet with name " .. options.name .. " already exists! Overwriting planet definition...") end
    table.remove(PlanetSelect.planets, exists)
  end

  if DEBUG then log("Adding planet " .. options.name) end

  ---@type PlanetSelectorDefinition
  local planet = {
    name = options.name,
    surface = options.surface,
    icon = options.icon or "unspecified-planet",
    first = true,
    callback = options.callback or nil,
    remote = options.remote or nil,
    auto = options.auto or nil,
  }

  table.insert(PlanetSelect.planets, planet)

  PlanetSelect.enable_planet(options.name)
end

PlanetSelect.add_planet_remote = function(options)
  table.insert(PlanetSelect.api_planets, options)
  PlanetSelect.add_planet(options)
end

remote.add_interface("planet-picker", {
  add_planet = PlanetSelect.add_planet_remote
})

PlanetSelect.reload_planets = function()
  PlanetSelect.planets = {}
  for n, p in pairs(game.planets) do
    if not blacklisted(n) then
      local modded_setting = settings.global["planet-picker-modded-planets"]
      local scan_modded = modded_setting and modded_setting.value

      local sprite = "planet-picker-" .. n
      if not helpers.is_valid_sprite_path(sprite) then
        sprite = "unspecified-planet"
      end

      if find_in(PlanetSelect.vanilla_planets, { name = n }) then

        local planet_setting = settings.global["planet-picker-" .. n]
        local enabled = planet_setting and planet_setting.value == true

        if enabled then
          PlanetSelect.add_planet({
            name = n,
            tooltip = n:sub(1, 1):upper() .. n:sub(2),
            icon = "planet-picker-" .. n,
            surface = n,
          })
          if DEBUG then log("Planet " .. n .. " was added as a vanilla planet.") end
        else
          if DEBUG then log("Planet " .. n .. " was vanilla but was not enabled.") end
        end
      elseif find_in(PlanetSelect.api_planets, { name = n }) then
        PlanetSelect.add_planet({
          name = n,
          tooltip = n:sub(1, 1):upper() .. n:sub(2),
          icon = "planet-picker-" .. n,
          surface = n,
        })
        if DEBUG then log("Planet " .. n .. " was added as a modded planet.") end
      elseif scan_modded then
        PlanetSelect.add_planet({
          name = n,
          tooltip = n:sub(1, 1):upper() .. n:sub(2),
          icon = "planet-picker-" .. n,
          surface = n,
          auto = true,
        })
        if DEBUG then log("Planet " .. n .. " was automatically added with best-effort.") end
      else
        if DEBUG then log("Planet " .. n .. " was not found in either list.") end
      end
    else
      if DEBUG then log("Planet " .. n .. " was blacklisted and therefore skipped.") end
    end
  end
end

PlanetSelect.enable_planet = function(name)
  if not game.planets[name].surface then
    game.planets[name].create_surface()
  end
  local radius = 5
  game.surfaces[name].request_to_generate_chunks({ 0, 0 }, radius)
  -- game.surfaces[name].force_generate_chunk_requests()
end

-- function moved_surface(e)
--   if e.player_index == nil or e.surface_index == nil then return end
--   local player = game.players[e.player_index]
--   if not player.controller_type == defines.controllers.character then return end

--   local surface = player.surface
--   local planet = PlanetSelect.planets[find_in(PlanetSelect.planets, { name = surface.name })]

--   if planet ~= nil then
--     -- Make sure the planet we're visiting is not hidden from the surface view.
--     player.force.set_surface_hidden(surface, false);
--     -- Make sure we unlock the tech for this planet.
--     unlock_planet_technology(player.force, surface)
--   end
-- end

-- script.on_event(defines.events.on_player_changed_surface, moved_surface)
