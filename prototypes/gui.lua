styles = data.raw["gui-style"].default

styles.select_planet_button = {
  type = "button_style",
  parent = "big_slot_button",
  size = 256 + 16,
  font = "default-bold",
  left_click_sound = {{ filename = "__core__/sound/gui-click.ogg", volume = 1 }},
  default_graphical_set = table.deepcopy(styles.big_slot_button.default_graphical_set),
  hovered_graphical_set = table.deepcopy(styles.big_slot_button.hovered_graphical_set),
  clicked_graphical_set = table.deepcopy(styles.big_slot_button.clicked_graphical_set),
  disabled_graphical_set = table.deepcopy(styles.big_slot_button.disabled_graphical_set),
  padding = 8,
}

styles.planet_loading_bar = {
  type = "progressbar_style",
  parent = "progressbar",
  width = 256,
}

styles.select_planet_button.hovered_graphical_set.glow = nil
