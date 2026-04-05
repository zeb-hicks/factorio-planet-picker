--- Grabs the planets from the PlanetSelect class and sanitises the sprites for the GUI.
function read_planets()
  PlanetSelect.reload_planets()
  local planet_table = {}
  for _, planet in pairs(PlanetSelect.planets) do
    -- If we haven't generated a valid sprite for this planet, use the placeholder.
    local sprite = "planet-picker-" .. planet.name
    if not helpers.is_valid_sprite_path(sprite) then
      sprite = "unspecified-planet"
    end

    table.insert(planet_table,
      { name = planet.name, sprite = sprite, tooltip = planet.name:sub(1, 1):upper() .. planet.name:sub(2) })
  end

  return planet_table
end

--- Build the player's UI from scratch.
---@param player LuaPlayer
GUI.make_startup_window = function(player)
  if DEBUG then log("GUI.make_startup_window for "..player.name) end

  -- Create the window and attach it to the center GUI anchor.
  local gui = player.gui.center
  local frame = gui.add { type = "frame", name = "pp_startup_window", caption = "Choose a Planet", style = "frame" } -- TODO: Localise
  frame.style.use_header_filler = false
  frame.style.left_margin = 16
  frame.style.right_margin = 16
  frame.style.natural_width = 1000
  frame.style.maximal_width = 1000

  -- Vertical flow, contains the planet picker and the lower pane.
  local main_flow = frame.add { type = "flow", name = "pp_main-flow", direction = "vertical", style = "planet_picker_main_frame" }

  -- Error message for when no planets are available.
  local no_planet_error = main_flow.add { type = "label", name = "pp_no_planet_error" }
  no_planet_error.style.font = "planet-picker-big-heading"
  no_planet_error.caption = "No Planets Available!"

  -- Scroll pane for the planet buttons.
  local planet_scroller = main_flow.add { type = "scroll-pane" }
  planet_scroller.vertical_scroll_policy = "never"
  planet_scroller.horizontal_scroll_policy = "always"

  -- Horizontal flow inside the scroll pane, contains the planet buttons.
  local planet_flow = planet_scroller.add { type = "flow", name = "pp_startup_planet_flow", direction = "horizontal" }
  planet_flow.style.natural_width = 1
  planet_flow.style.horizontally_squashable = true

  -- Left padding to center the planets.
  local pre = planet_flow.add { type = "empty-widget" }
  pre.style.horizontally_stretchable = true

  local ui_store = storage.ui[player.index]

  local planets = read_planets()

  -- If the player's currently selected planet isn't in the list of planets, or is invalid, reset it.
  if storage.ui[player.index].selected_planet == nil then
    storage.ui[player.index].selected_planet = ""
  elseif not find_in(planets, { name = storage.ui[player.index].selected_planet }) then
    storage.ui[player.index].selected_planet = ""
  end

  -- Show the no planets error if there are no planets, else show the planets.
  planet_scroller.visible = #planets > 0
  no_planet_error.visible = #planets == 0

  -- Default planet selection to the first available if we don't have one.
  if ui_store.selected_planet == nil and #planets > 0 then
    ui_store.selected_planet = planets[1].name
  end

  -- Add the planet buttons.
  for _, planet in pairs(planets) do
    if planet.name == ui_store.selected_planet then
      planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button_current", sprite = planet.sprite }
    else
      planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button", sprite = planet.sprite }
    end
  end

  -- Right padding to center the planets.
  local post = planet_flow.add { type = "empty-widget" }
  post.style.horizontally_stretchable = true

  -- Lower flow pane containing the details and remote preview.
  local lower_flow = main_flow.add { type = "flow", name = "pp_lower_flow", direction = "horizontal", style = "planet_picker_lower_frame" }

  -- Left vertical flow for the details and spawn button.
  local left_flow = lower_flow.add { type = "flow", name = "pp_left_flow", direction = "vertical" }
  left_flow.style.vertical_spacing = 12

  -- Remote preview frame.
  local preview_frame = lower_flow.add { type = "frame", name = "pp_preview_frame", style = "inside_deep_frame" }

  -- Planet details frame.
  local detail_frame = left_flow.add { type = "frame", name = "pp_detail_frame", style = "inside_deep_frame" }
  detail_frame.style.natural_width = 320
  detail_frame.style.vertically_stretchable = true

  -- Planet details inner vertical flow.
  local detail_flow = detail_frame.add { type = "flow", name = "pp_detail_flow", direction = "vertical", style = "planet_picker_detail_frame" }
  build_planet_details(player, detail_flow, ui_store.selected_planet)

  -- Filler to push the spawn button to the bottom of the parent flow.
  local filler = detail_flow.add { type = "empty-widget" }
  filler.style.vertically_stretchable = true

  -- Big friendly green spawn button.
  local spawn_button = left_flow.add { type = "button", name = "pp_spawn_button", caption = "Spawn", style = "confirm_button", enabled = false }
  spawn_button.style.horizontally_stretchable = true

  -- Decide whether the spawn button should be enabled.
  local game_planet = game.planets[ui_store.selected_planet]
  local surf_index = game.surfaces["empty_void"].index
  if game_planet then
    surf_index = game_planet.surface.index
    spawn_button.enabled = true
  end

  -- Remote camera view of the planet.
  local view = preview_frame.add { type = "camera", name = "pp_remote_view", style = "planet_picker_remote_view", surface_index = surf_index, position = { 0, 0 }, zoom = 0.25 }

  -- Store references to the important UI elements for later.
  storage.ui[player.index].elements = {
    planet_flow = planet_flow,
    detail_flow = detail_flow,
    planet_container = planet_scroller,
    no_planet_error = no_planet_error,
    spawn_button = spawn_button,
    view = view
  }
end

---@class UIStorageElements
---@field planet_flow LuaGuiElement
---@field detail_flow LuaGuiElement
---@field planet_container LuaGuiElement
---@field no_planet_error LuaGuiElement
---@field spawn_button LuaGuiElement
---@field view LuaGuiElement

--- Dynamically update the state of the player's UI
GUI.update_startup_window = function(player)
  local ui_store = storage.ui[player.index]

  if not ui_store.elements then return end
  ---@type UIStorageElements
  local elements = ui_store.elements
  local planets = read_planets()

  elements.planet_flow.clear()

  local pre = elements.planet_flow.add { type = "empty-widget" }
  pre.style.horizontally_stretchable = true

  elements.planet_container.visible = #planets > 0
  elements.no_planet_error.visible = #planets == 0

  for _, planet in pairs(planets) do
    if planet.name == ui_store.selected_planet then
      elements.planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button_current", sprite = planet.sprite }
    else
      elements.planet_flow.add { type = "sprite-button", name = "pp_start_on_" .. planet.name, tooltip = planet.tooltip, style = "select_planet_button", sprite = planet.sprite }
    end
  end

  local post = elements.planet_flow.add { type = "empty-widget" }
  post.style.horizontally_stretchable = true

  elements.detail_flow.clear()
  build_planet_details(player, elements.detail_flow, ui_store.selected_planet)

  local filler = elements.detail_flow.add { type = "empty-widget" }
  filler.style.vertically_stretchable = true

  local planet = game.planets[ui_store.selected_planet]
  elements.view.surface_index = planet.surface.index

  elements.spawn_button.enabled = ui_store.selected_planet ~= ""
end

--- Add the detail items to the planet detail pane
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
  local forces = {}
  local players = {}
  if surface ~= nil then
    for k,p in pairs(game.players) do
      if p.surface_index == surface.index then
        table.insert(players, p.name)
        forces[p.force.name] = true
      end
    end

    local first_force = true
    for f,_ in pairs(forces) do
      if first_force then
        first_force = false
        local label = details_list.add { type = "label", caption = "Forces:" }
        label.style.font = "heading-2"
        label.style.font_color = { r = 220, g = 200, b = 140 }
      end
      local force_name = human_readable_name(f)
      local label = details_list.add { type = "label", caption = force_name }
      label.style.left_padding = 8
    end

    local first_player = true
    for _,p in pairs(players) do
      if first_player then
        first_player = false
        local label = details_list.add { type = "label", caption = "Players:" }
        label.style.font = "heading-2"
        label.style.font_color = { r = 220, g = 200, b = 140 }
      end
      local r = game.players[p].color.r
      local g = game.players[p].color.g
      local b = game.players[p].color.b
      local dot = "[color=" .. r .. "," .. g .. "," .. b .. "]●[/color] "
      local set = details_list.add { type = "flow", direction = "horizontal" }
      local label = set.add { type = "label", caption = dot .. p }
      label.style.left_padding = 8
      if not game.players[p].connected then
        label.caption = "[color=0.5,0.5,0.5]" .. label.caption .. "[/color]"
        local icon = set.add { type = "sprite", sprite = "planet-picker-disconnected" }
        icon.style.size = { 12, 12 }
        icon.style.stretch_image_to_widget_size = true
        icon.style.vertical_align = "center"
        icon.style.margin = 4
      end
    end
  end
end

---@param flow LuaGuiElement
---@param caption string
function add_detail(flow, caption)
  local label = flow.add { type = "label", caption = caption }
  label.style.horizontally_stretchable = true
end

GUI.close_startup_window = function(player)
  if DEBUG then log("GUI.close_startup_window for "..player.name) end
  ---@type LuaGuiElement
  local gui = player.gui.center
  if gui.pp_startup_window then
    gui.pp_startup_window.destroy()
  end
end

---@param player LuaPlayer
GUI.rebuild = function(player)
  if DEBUG then log("GUI.rebuild for "..player.name) end
  if player and player.gui and player.gui.center.pp_startup_window then
    GUI.close_startup_window(player)

    storage.ui[player.index].selected_planet = storage.ui[player.index].selected_planet or ""

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
    GUI.update_startup_window(player)
  end

  if clicked_start then
    PlanetSelect.start_on(ui_store.selected_planet, game.players[e.player_index])
    GUI.close_startup_window(game.players[e.player_index])
  end
end

---@param e ConfigurationChangedData
function config_changed(e)
  setup_storage()
  for _, p in pairs(game.players) do
    -- GUI.update_startup_window(p)
    GUI.rebuild(p)
  end
end

script.on_event(defines.events.on_gui_click, gui_click)
script.on_configuration_changed(config_changed)