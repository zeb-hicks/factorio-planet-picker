GUI = GUI or {}

---@param player LuaPlayer
GUI.make_startup_window = GUI.make_startup_window or function(player)
  local gui = player.gui.center
  local frame = gui.add{type = "frame", name = "startup_window", caption = "Choose a Planet", style="frame"} -- TODO: Localise
  local flow = frame.add{type = "flow", name = "startup_planet_flow", direction = "horizontal"}
  local nauvis_button = flow.add{type = "sprite-button", name = "start-on-nauvis", tooltip = "Nauvis", style="select_planet_button", sprite="nauvis"}
  local gleba_button = flow.add{type = "sprite-button", name = "start-on-gleba", tooltip = "Gleba", style="select_planet_button", sprite="gleba"}
  local fulgora_button = flow.add{type = "sprite-button", name = "start-on-fulgora", tooltip = "Fulgora", style="select_planet_button", sprite="fulgora"}
  local vulcanus_button = flow.add{type = "sprite-button", name = "start-on-vulcanus", tooltip = "Vulcanus", style="select_planet_button", sprite="vulcanus"}
end

GUI.close_startup_window = GUI.close_startup_window or function(player)
  local gui = player.gui.center
  if gui.startup_window then
    gui.startup_window.destroy()
  end
end