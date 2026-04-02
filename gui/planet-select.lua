GUI.planets = GUI.planets or {}

GUI.setup = function(planets)
  GUI.planets = {}
  for _, planet in pairs(planets) do
    if not blacklisted(planet.name) then
      local planet_setting = settings.global["planet-picker-"..planet.name]
      if planet_setting ~= nil then
        if planet_setting.value then
          table.insert(GUI.planets, {name = planet.name, sprite = planet.icon or "unspecified-planet", tooltip = planet.tooltip})
        end
      else
        local sprite = "planet-picker-"..planet.name
        if not helpers.is_valid_sprite_path(sprite) then
          sprite = "unspecified-planet"
        end
        if settings.global["planet-picker-modded-planets"].value then
          table.insert(GUI.planets, {name = planet.name, sprite = sprite, tooltip = planet.name:sub(1,1):upper()..planet.name:sub(2)})
        elseif planet.auto then
          table.insert(GUI.planets, {name = planet.name, sprite = sprite, tooltip = planet.name:sub(1,1):upper()..planet.name:sub(2)})
        end
      end
    end
  end
end

---@param player LuaPlayer
GUI.make_startup_window = GUI.make_startup_window or function(player)
  local gui = player.gui.center
  local frame = gui.add{type = "frame", name = "startup_window", caption = "Choose a Planet", style="frame"} -- TODO: Localise
  local flow = frame.add{type = "flow", name = "startup_planet_flow", direction = "horizontal"}
  for _, planet in pairs(GUI.planets) do
    local button = flow.add{type = "sprite-button", name = "start-on-"..planet.name, tooltip = planet.tooltip, style="select_planet_button", sprite=planet.sprite}
  end
end

GUI.close_startup_window = GUI.close_startup_window or function(player)
  ---@type LuaGuiElement
  local gui = player.gui.center
  if gui.startup_window then
    gui.startup_window.destroy()
  end
end

GUI.update = function(player, planets)
  if player.gui.center.startup_window then
    GUI.close_startup_window(player)
    GUI.setup(planets)
    GUI.make_startup_window(player)
  end
end

function gui_click(e)
  local force = game.forces.player
  local match = e.element.name:match("start%-on%-(%w+)")
  if not match then return end
  PlanetSelect.start_on(match, game.players[e.player_index])
  GUI.close_startup_window(game.players[e.player_index])
end

script.on_event(defines.events.on_gui_click, gui_click)