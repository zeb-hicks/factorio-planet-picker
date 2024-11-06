data.extend({
  {
    type = "technology",
    name = "carbon-steel",
    icons = {
      {
        icon = "__base__/graphics/technology/steel-processing.png",
        icon_size = 256,
      },
      {
        icon = "__space-age__/graphics/icons/carbon.png",
        icon_size = 64,
        scale = 1.0,
        shift = { 24, 24 },
      },
    },
    icon_size = 128,
    effects = {
      { type = "unlock-recipe", recipe = "iron-carbide-powder" },
      { type = "unlock-recipe", recipe = "carbon-steel" },
      { type = "unlock-recipe", recipe = "thermal-vent" },
    },
    research_trigger = {
      type = "mine-entity",
      entity = "huge-volcanic-rock",
    }
  }
})
