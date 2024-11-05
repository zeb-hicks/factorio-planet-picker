require("gui/startup")

local inventory_storage = {}

function chart_starting_area(surface)
  local r = storage.chart_distance or 200
  local force = game.forces.player
  local origin = force.get_spawn_position(surface)
  force.chart(surface, {{origin.x - r, origin.y - r}, {origin.x + r, origin.y + r}})
end

function gui_click(e)
  local force = game.forces.player
  if e.element.name == "start-on-nauvis" then
    start_on("nauvis", game.players[e.player_index])
  elseif e.element.name == "start-on-gleba" then
    start_on("gleba", game.players[e.player_index])
  elseif e.element.name == "start-on-fulgora" then
    start_on("fulgora", game.players[e.player_index])
  elseif e.element.name == "start-on-vulcanus" then
    start_on("vulcanus", game.players[e.player_index])
  else
    return
  end
  GUI.close_startup_window(game.players[e.player_index])
end

function start_on(planet, player)
  local force = game.forces.player;
  player.force = force
  player.minimap_enabled = true

  local surface = game.surfaces[planet]
  local position = surface.find_non_colliding_position("character", force.get_spawn_position(surface), surface.get_starting_area_radius(), 2)
  log(serpent.block(position))
  player.teleport(position, surface)

  local character = surface.create_entity({name = "character", position = position or {0, 0}, force = force})
  player.set_controller({type = defines.controllers.character, character = character})
  for _, item in pairs(inventory_storage[player.index]) do
    player.get_inventory(item.inventory).insert(item.item)
  end
end

function init()
  game.create_force("picking_planet")
  create_empty_void()
  game.forces.player.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.nauvis, true)
  game.forces.picking_planet.disable_research()
  game.forces.picking_planet.disable_all_prototypes()

  game.planets.gleba.create_surface()
  game.planets.fulgora.create_surface()
  game.planets.vulcanus.create_surface()

  game.surfaces.gleba.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.fulgora.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.vulcanus.request_to_generate_chunks({0, 0}, 8)

  game.forces.player.chart(game.surfaces.gleba, {{-200, -200}, {200, 200}})
  game.forces.player.chart(game.surfaces.fulgora, {{-200, -200}, {200, 200}})
  game.forces.player.chart(game.surfaces.vulcanus, {{-200, -200}, {200, 200}})
  game.forces.picking_planet.chart(game.surfaces.gleba, {{-200, -200}, {200, 200}})
  game.forces.picking_planet.chart(game.surfaces.fulgora, {{-200, -200}, {200, 200}})
  game.forces.picking_planet.chart(game.surfaces.vulcanus, {{-200, -200}, {200, 200}})

  game.forces.player.set_surface_hidden(game.planets.gleba.surface, false)
  game.forces.player.set_surface_hidden(game.planets.fulgora.surface, false)
  game.forces.player.set_surface_hidden(game.planets.vulcanus.surface, false)

  -- game.forces.player.unlock_space_location("gleba")
  -- game.forces.player.unlock_space_location("fulgora")
  -- game.forces.player.unlock_space_location("vulcanus")

  game.forces.player.technologies["planet-discovery-gleba"].researched = true
  game.forces.player.technologies["planet-discovery-fulgora"].researched = true
  game.forces.player.technologies["planet-discovery-vulcanus"].researched = true

  if remote.interfaces["freeplay"] then
    remote.call("freeplay", "set_disable_crashsite", true)
    remote.call("freeplay", "set_skip_intro", true)
    remote.call("freeplay", "set_ship_items", {})
    remote.call("freeplay", "set_debris_items", {})
  end

  chart_starting_area(game.planets.gleba.surface)
  chart_starting_area(game.planets.fulgora.surface)
  chart_starting_area(game.planets.vulcanus.surface)
end

function create_empty_void()
  local surface = game.create_surface("empty_void", {
    seed = 0,
    width = 100,
    height = 100,
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
  surface.generate_with_lab_tiles = true
  for x = -50, 50 do
    for y = -50, 50 do
      surface.set_tiles({{position = {x, y}, name = "empty-space" }})
    end
  end
end

function collect_items_from(player)
  local items = {}
  for _, item in pairs(player.get_inventory(defines.inventory.character_main).get_contents()) do
    table.insert(items, { item = item, inventory = defines.inventory.character_main })
  end
  for _, item in pairs(player.get_inventory(defines.inventory.character_guns).get_contents()) do
    table.insert(items, { item = item, inventory = defines.inventory.character_guns })
  end
  for _, item in pairs(player.get_inventory(defines.inventory.character_ammo).get_contents()) do
    table.insert(items, { item = item, inventory = defines.inventory.character_ammo })
  end
  for _, item in pairs(player.get_inventory(defines.inventory.character_armor).get_contents()) do
    table.insert(items, { item = item, inventory = defines.inventory.character_armor })
  end
  for _, item in pairs(player.get_inventory(defines.inventory.character_trash).get_contents()) do
    table.insert(items, { item = item, inventory = defines.inventory.character_trash })
  end
  return items
end

function player_created(e)
  local player = game.players[e.player_index]
  local character = player.character
  local items = collect_items_from(player)
  inventory_storage[player.index] = items

  if character then character.destroy() end

  player.force = game.forces.picking_planet

  player.set_controller({type = defines.controllers.spectator})
  player.teleport({0, 0}, game.surfaces.empty_void)
  player.minimap_enabled = false

  GUI.make_startup_window(player)
end

script.on_event(defines.events.on_game_created_from_scenario, init)
-- script.on_init(init)
script.on_event(defines.events.on_player_created, player_created)
script.on_event(defines.events.on_gui_click, gui_click)