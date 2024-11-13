GUI.loading = {}

---@param name string
---@param value number
GUI.progress = function(name, value)
  GUI.loading[name] = GUI.loading[name] or {}
  local loading = GUI.loading[name]

  loading.value = value
  for _, player in pairs(game.players) do
    GUI.update_progress(player)
  end
end

---@param player LuaPlayer
GUI.spawn_loading_screen = function(player)
  local gui = player.gui.center
  local frame = gui.add{type = "frame", name = "loading_screen", caption = "Loading...", style="frame"}
  local flow = frame.add{type = "flow", name = "loading_flow", direction = "vertical"}
  local progress_bar = flow.add{type = "progressbar", name = "loading_progress", value = 0, style="planet_loading_bar" }
  -- for _, planet in pairs(PlanetSelect.planets) do
  --   flow.add{type = "label", name = planet.name.."_progress", caption = planet.name..": 0/0"}
  -- end
end

GUI.update_progress = function(player)
  local progress = 0
  local total = 0
  for _, loading in pairs(GUI.loading) do
    progress = progress + loading.value
    total = total + 1
  end
  local value = progress / total

  local progress_bar = nil_chain(player.gui.center, "loading_screen", "loading_flow", "loading_progress")
  if not progress_bar then return end
  progress_bar.value = value

  -- for k, v in pairs(PlanetSelect.progress) do
  --   local label = player.gui.center.loading_screen.loading_flow[k.."_progress"]
  --   if label then
  --     local generated = math.floor((v.chunks.generated / v.chunks.total) * 100) .. "%"
  --     local charted = math.floor((v.chart.charted / v.chart.total) * 100) .. "%"
  --     label.caption = k..": Generated "..generated.." Charted "..charted
  --   end
  -- end

  if value == 1 then
    player.gui.center.loading_screen.destroy()
    GUI.make_startup_window(player)
  end
end
