function read_planets()
  if DEBUG then log("GUI.setup") end
  PlanetSelect.reload_planets()
  if DEBUG then log(serpent.block(PlanetSelect.planets)) end
  local planet_table = {}
  for _, planet in pairs(PlanetSelect.planets) do
    if DEBUG then log("GUI.setup for "..planet.name) end

    local sprite = "planet-picker-" .. planet.name
    if not helpers.is_valid_sprite_path(sprite) then
      sprite = "unspecified-planet"
    end

    table.insert(planet_table,
      { name = planet.name, sprite = sprite, tooltip = planet.name:sub(1, 1):upper() .. planet.name:sub(2) })
  end

  return planet_table
end

---@param player LuaPlayer
GUI.make_startup_window = GUI.make_startup_window or function(player)
  if DEBUG then log("GUI.make_startup_window for "..player.name) end
  -- GUI.setup(PlanetSelect.planets)
  local gui = player.gui.center
  local frame = gui.add { type = "frame", name = "pp_startup_window", caption = "Choose a Planet", style = "frame" } -- TODO: Localise

  local main_flow = frame.add { type = "flow", name = "pp_main-flow", direction = "vertical", style = "planet_picker_main_frame" }

  local planet_flow = main_flow.add { type = "flow", name = "pp_startup_planet_flow", direction = "horizontal" }
  planet_flow.style.horizontally_stretchable = true

  local pre = planet_flow.add { type = "empty-widget" }
  pre.style.horizontally_stretchable = true

  if DEBUG then log("Player ui store:") end
  if DEBUG then log(serpent.block(storage.ui[player.index])) end
  local ui_store = storage.ui[player.index]

  local planets = read_planets()

  for _, planet in pairs(planets) do
    if planet.name == ui_store.selected_planet then
      planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button_current", sprite = planet.sprite }
    else
      planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button", sprite = planet.sprite }
    end
  end

  local post = planet_flow.add { type = "empty-widget" }
  post.style.horizontally_stretchable = true

  local lower_flow = main_flow.add { type = "flow", name = "pp_lower_flow", direction = "horizontal", style = "planet_picker_lower_frame" }

  local left_flow = lower_flow.add { type = "flow", name = "pp_left_flow", direction = "vertical" }
  left_flow.style.vertical_spacing = 12

  local preview_frame = lower_flow.add { type = "frame", name = "pp_preview_frame", style = "inside_deep_frame" }

  local detail_frame = left_flow.add { type = "frame", name = "pp_detail_frame", style = "inside_deep_frame" }
  detail_frame.style.natural_width = 320
  detail_frame.style.vertically_stretchable = true

  local detail_flow = detail_frame.add { type = "flow", name = "pp_detail_flow", direction = "vertical", style = "planet_picker_detail_frame" }

  build_planet_details(player, detail_flow, ui_store.selected_planet)

  local spawn_button = left_flow.add { type = "button", name = "pp_spawn_button", caption = "Spawn", style = "confirm_button" }
  spawn_button.style.horizontally_stretchable = true

  local game_planet = game.planets[ui_store.selected_planet]
  local surf_index = game_planet.surface.index
  local view = preview_frame.add { type = "camera", name = "pp_remote_view", style = "planet_picker_remote_view", surface_index = surf_index, position = { 0, 0 }, zoom = 0.25 }
end

---@param player LuaPlayer
---@param flow LuaGuiElement
---@param planet string
function build_planet_details(player, flow, planet)
  if DEBUG then log("GUI.build_planet_details for "..player.name) end
  local name_frame = flow.add { type = "frame", style = "subheader_frame" }
  name_frame.style.horizontally_stretchable = true

  local planet_name = name_frame.add { type = "label", caption = planet:sub(1,1):upper()..planet:sub(2), style = "frame_title" }
  planet_name.style.font = "default-large-bold"

  local details_list = flow.add { type = "flow", direction = "vertical" }
  details_list.style.left_padding = 8
  details_list.style.right_padding = 8

  local surface = game.get_surface(planet)
  local current_players = 0
  local players = {}
  if surface ~= nil then
    for k,p in pairs(game.players) do
      if p.surface_index == surface.index then
        current_players = current_players + 1
        table.insert(players, p.name)
      end
    end
  end

  add_detail(details_list, "Current players: "..current_players)

  for _,p in pairs(players) do
    add_detail(details_list, p)
  end

  local filler = flow.add { type = "empty-widget" }
  filler.style.vertically_stretchable = true
end

---@param flow LuaGuiElement
---@param caption string
function add_detail(flow, caption)
  local label = flow.add { type = "label", caption = caption }
  label.style.horizontally_stretchable = true
end

GUI.close_startup_window = GUI.close_startup_window or function(player)
  if DEBUG then log("GUI.close_startup_window for "..player.name) end
  ---@type LuaGuiElement
  local gui = player.gui.center
  if gui.pp_startup_window then
    gui.pp_startup_window.destroy()
  end
end

GUI.update = function(player)
  if DEBUG then log("GUI.update for "..player.name) end
  if player and player.gui and player.gui.center.pp_startup_window then
    GUI.close_startup_window(player)
    GUI.make_startup_window(player)
  end
end

function gui_click(e)
  local force = game.forces.player
  local clicked_planet = e.element.name:match("pp_start%_on%_(%w+)")
  local clicked_start = e.element.name == "pp_spawn_button"

  local player = game.players[e.player_index]
  if DEBUG then log("gui_click for "..player.name.." on "..e.element.name) end
  if DEBUG then log(serpent.block(storage.ui)) end
  if DEBUG then log(serpent.block(storage.ui[player.index])) end
  local ui_store = storage.ui[player.index]

  if clicked_planet ~= nil then
    ui_store.selected_planet = clicked_planet
    GUI.update(player)
  end

  if clicked_start then
    PlanetSelect.start_on(ui_store.selected_planet, game.players[e.player_index])
    GUI.close_startup_window(game.players[e.player_index])
  end
end

---@param e ConfigurationChangedData
function config_changed(e)
  for _, p in pairs(game.players) do
    GUI.update(p)
  end
end

script.on_event(defines.events.on_gui_click, gui_click)
script.on_configuration_changed(config_changed)