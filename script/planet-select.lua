require("utils")

PlanetSelect = PlanetSelect or {}

PlanetSelect.start_on = function(planet, player)
  local force = game.forces.player;
  player.force = force
  player.minimap_enabled = true

  local surface = game.surfaces[planet]
  local position = surface.find_non_colliding_position("character", force.get_spawn_position(surface), surface.get_starting_area_radius(), 2)

  unlock_planet_technology(force, surface)

  dlog("Starting on " .. planet)
  local planet_data = find_in(PlanetSelect.planets, { name = planet })
  if planet_data ~= nil then
    dlog("Planet data found for " .. planet)
    planet_data = PlanetSelect.planets[planet_data]
    dlog(serpent.block(planet_data))
    if planet_data.callback then planet_data.callback(player, planet_data.first) end
  end

  player.teleport(position, surface)

  local character = surface.create_entity({name = "character", position = position or {0, 0}, force = force})
  player.set_controller({type = defines.controllers.character, character = character})
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
    cliff_settings = {cliff_elevation_0 = 0, cliff_elevation_interval = 0, name = "cliff", richness = 0, control = "cliff", cliff_smoothing = 0},
    starting_points = {{x = 0, y = 0}},
    territory_settings = {
      units = {""},
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
      surface.set_tiles({{position = {x, y}, name = "empty-space" }})
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
function gleba_setup(player, first)
  dlog("Setting up Gleba")

end

---@param player LuaPlayer
---@param first boolean
function fulgora_setup(player, first)
  dlog("Setting up Fulgora")

end

---@param player LuaPlayer
---@param first boolean
function vulcanus_setup(player, first)
  dlog("Setting up Vulcanus via callback")
  for _, force in pairs(game.forces) do
    dlog("Unlocking acid processing for "..force.name.." force")
    force.technologies["acid-processing"].enabled = true
    force.recipes["thermal-vent"].enabled = true
  end
end

PlanetSelect.planets = {
  { name = "nauvis", tooltip = "Nauvis", icon = "nauvis", surface = "nauvis", first = true },
  { name = "gleba", tooltip = "Gleba", icon = "gleba", surface = "gleba", first = true, callback = gleba_setup },
  { name = "fulgora", tooltip = "Fulgora", icon = "fulgora", surface = "fulgora", first = true, callback = fulgora_setup },
  { name = "vulcanus", tooltip = "Vulcanus", icon = "vulcanus", surface = "vulcanus", first = true, callback = vulcanus_setup },
  { name = "aquilo", tooltip = "Aquilo", icon = "aquilo", surface = "aquilo", first = true },
}

PlanetSelect.add_planet = function(options)
  if not options or type(options) ~= "table" then error("add_planet expects a table of options defining the new planet") end
  if not options.name then error("add_planet requires a name parameter") end
  if not options.surface then error("add_planet requires a surface parameter") end
  local exists = find_in(PlanetSelect.planets, { name = options.name })
  if exists then error("Planet with name " .. options.name .. " already exists") end

  dlog("Adding planet " .. options.name)

  local planet = {
    name = options.name,
    surface = options.surface,
    icon = options.icon or "unspecified_planet",
    first = true,
    callback = options.callback or function() end
  }

  table.insert(PlanetSelect.planets, planet)

  PlanetSelect.enable_planet(options.name)
end

PlanetSelect.setup_planets = function()
  game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)

  for _, planet in pairs(PlanetSelect.planets) do
    PlanetSelect.enable_planet(planet.name)
  end
end

PlanetSelect.progress = {}

PlanetSelect.enable_planet = function(name)
  local radius = 5
  game.planets[name].create_surface()
  game.surfaces[name].request_to_generate_chunks({0, 0}, radius)
  local area = (radius * 2 + 1) ^ 2
  PlanetSelect.progress[name] = {
    chunks = { generated = 0, total = area },
    chart = { charted = 0, total = area }
  }
end

---@param e EventData.on_chunk_generated
function chunk_generated(e)
  if not PlanetSelect.progress or not PlanetSelect.progress[e.surface.name] then return end
  local progress = PlanetSelect.progress[e.surface.name].chunks

  progress.generated = progress.generated + 1
  GUI.progress(e.surface.name.."_gen", progress.generated / progress.total)

  if progress.generated == progress.total then
    chart_starting_area(e.surface)
  end
end

---@param e EventData.on_chunk_charted
function chunk_charted(e)
  local surface = game.surfaces[e.surface_index]
  if not PlanetSelect.progress or not PlanetSelect.progress[surface.name] then return end
  local progress = PlanetSelect.progress[surface.name].chart

  progress.charted = progress.charted + 1
  GUI.progress(surface.name.."_chart", progress.charted / progress.total)
end
script.on_event(defines.events.on_chunk_generated, chunk_generated)
script.on_event(defines.events.on_chunk_charted, chunk_charted)

function moved_surface(e)
  if not game.surfaces["empty_void"] then return end
  local player = game.players[e.player_index]
  local surface = game.surfaces[e.surface_index]

  if not player.controller_type == defines.controllers.character then return end
  if surface.name == "empty_void" then return end

  unlock_planet_technology(player.force, surface)
  player.force.set_surface_hidden(surface, false)
end

script.on_event(defines.events.on_player_changed_surface, moved_surface)