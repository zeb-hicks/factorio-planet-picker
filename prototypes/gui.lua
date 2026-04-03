styles = data.raw["gui-style"].default

styles.select_planet_button = {
  type = "button_style",
  parent = "big_slot_button",
  size = 128 + 16,
  font = "default-bold",
  left_click_sound = {{ filename = "__core__/sound/gui-click.ogg", volume = 1 }},
  default_graphical_set = table.deepcopy(styles.big_slot_button.default_graphical_set),
  hovered_graphical_set = table.deepcopy(styles.big_slot_button.hovered_graphical_set),
  clicked_graphical_set = table.deepcopy(styles.big_slot_button.clicked_graphical_set),
  disabled_graphical_set = table.deepcopy(styles.big_slot_button.disabled_graphical_set),
  horizontal_align = "center",
}
styles.select_planet_button.hovered_graphical_set.glow = nil

styles.select_planet_button_current = table.deepcopy(styles.select_planet_button)
styles.select_planet_button_current.default_graphical_set = table.deepcopy(styles.big_slot_button.hovered_graphical_set)
styles.select_planet_button_current.hovered_graphical_set.glow = nil
styles.select_planet_button_current.default_graphical_set.glow = nil

styles.planet_picker_remote_view = {
  type = "camera_style",
  natural_width = 800,
  natural_height = 480,
  horizontally_squashable = "on",
  vertically_squashable = "on",
}

styles.planet_picker_main_frame = {
  type = "vertical_flow_style",
  vertical_spacing = 12,
}

styles.planet_picker_lower_frame = {
  type = "horizontal_flow_style",
  horizontal_spacing = 12,
}

styles.planet_picker_detail_frame = {
  type = "vertical_flow_style",
  vertical_spacing = 8,
}

styles.planet_loading_bar = {
  type = "progressbar_style",
  parent = "progressbar",
  width = 256,
}
