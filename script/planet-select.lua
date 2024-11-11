require("utils")

function gui_click(e)
  local force = game.forces.player
  local match = e.element.name:match("start%-on%-(%w+)")
  if not match then return end
  start_on(match, game.players[e.player_index])
  GUI.close_startup_window(game.players[e.player_index])
end

function start_on(planet, player)
  local force = game.forces.player;
  player.force = force
  player.minimap_enabled = true

  local surface = game.surfaces[planet]
  local position = surface.find_non_colliding_position("character", force.get_spawn_position(surface), surface.get_starting_area_radius(), 2)

  unlock_planet_technology(force, surface)

  player.teleport(position, surface)

  local character = surface.create_entity({name = "character", position = position or {0, 0}, force = force})
  player.set_controller({type = defines.controllers.character, character = character})
  for _, item in pairs(storage.inventories[player.index]) do
    player.get_inventory(item.inventory).insert(item.item)
  end
end

function create_empty_void()
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

function setup_force()
  game.create_force("picking_planet")

  create_empty_void()
  game.forces.player.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.empty_void, true)
  game.forces.picking_planet.set_surface_hidden(game.surfaces.nauvis, true)
  game.forces.picking_planet.disable_research()
  game.forces.picking_planet.disable_all_prototypes()
end

function setup_planets()
  game.forces.player.set_surface_hidden(game.surfaces.nauvis, true)

  game.planets.gleba.create_surface()
  game.planets.fulgora.create_surface()
  game.planets.vulcanus.create_surface()
  game.planets.aquilo.create_surface()

  game.surfaces.gleba.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.fulgora.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.vulcanus.request_to_generate_chunks({0, 0}, 8)
  game.surfaces.aquilo.request_to_generate_chunks({0, 0}, 8)

  chart_starting_area(game.planets.gleba.surface)
  chart_starting_area(game.planets.fulgora.surface)
  chart_starting_area(game.planets.vulcanus.surface)
  chart_starting_area(game.planets.aquilo.surface)
end

function moved_surface(e)
  local player = game.players[e.player_index]
  local surface = game.surfaces[e.surface_index]

  log("Surface change for "..player.name.." to "..surface.name)
  log("Controller is "..player.controller_type)

  if not player.controller_type == defines.controllers.character then return end
  if surface.name == "empty_void" then return end

  unlock_planet_technology(player.force, surface)
  player.force.set_surface_hidden(surface, false)
end

script.on_event(defines.events.on_player_changed_surface, moved_surface)

script.on_event(defines.events.on_gui_click, gui_click)