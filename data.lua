require("utils.table")

data.raw["technology"]["planet-discovery-gleba"].prerequisites = {}
data.raw["technology"]["planet-discovery-fulgora"].prerequisites = {}
data.raw["technology"]["planet-discovery-vulcanus"].prerequisites = {}

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

styles.select_planet_button.hovered_graphical_set.glow = nil

data.extend({
  {
    type = "sprite",
    name = "nauvis",
    filename = "__planet-picker__/graphics/icons/nauvis.png",
    size = 512,
    scale = 1.0,
    priority = "high",
  },
  {
    type = "sprite",
    name = "gleba",
    filename = "__planet-picker__/graphics/icons/gleba.png",
    size = 512,
    scale = 1.0,
    priority = "high",
  },
  {
    type = "sprite",
    name = "fulgora",
    filename = "__planet-picker__/graphics/icons/fulgora.png",
    size = 512,
    scale = 1.0,
    priority = "high",
  },
  {
    type = "sprite",
    name = "vulcanus",
    filename = "__planet-picker__/graphics/icons/vulcanus.png",
    size = 512,
    scale = 1.0,
    priority = "high",
  }
})