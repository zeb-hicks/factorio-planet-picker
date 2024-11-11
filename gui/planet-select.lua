GUI = GUI or {}

GUI.planets = GUI.planets or {}

table.insert(GUI.planets, {name = "nauvis", sprite = "nauvis", tooltip = "Nauvis"})
table.insert(GUI.planets, {name = "gleba", sprite = "gleba", tooltip = "Gleba"})
table.insert(GUI.planets, {name = "fulgora", sprite = "fulgora", tooltip = "Fulgora"})
table.insert(GUI.planets, {name = "vulcanus", sprite = "vulcanus", tooltip = "Vulcanus"})
if settings.startup["planet-picker-aquilo"].value then
  table.insert(GUI.planets, {name = "aquilo", sprite = "aquilo", tooltip = "Aquilo"})
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
  local gui = player.gui.center
  if gui.startup_window then
    gui.startup_window.destroy()
  end
end

script.on_event(defines.events.on_gui_click, gui_click)