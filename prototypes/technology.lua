data.extend({
  {
    type = "technology",
    name = "acid-processing",
    icons = {
      {
        icon = "__base__/graphics/technology/oil-processing.png",
        icon_size = 256,
      },
      {
        icon = "__base__/graphics/icons/fluid/sulfuric-acid.png",
        icon_size = 64,
        scale = 1.0,
        shift = { 24, 24 },
      },
    },
    enabled = false,
    icon_size = 128,
    effects = {
      { type = "unlock-recipe", recipe = "oil-refinery" },
      { type = "unlock-recipe", recipe = "simple-coal-liquefaction" },
    },
    prerequisites = { "planet-discovery-vulcanus", "fluid-handling" },
    research_trigger = {
      type = "build-entity",
      entity = "pumpjack",
    }
  },
  {
    type = "technology",
    name = "planet-discovery-nauvis",
    icons = {
      {
        icon = "__planet-picker__/graphics/technology/nauvis.png",
        icon_size = 256,
      },
      {
        icon = "__core__/graphics/icons/technology/constants/constant-planet.png",
        icon_size = 128,
        scale = 0.5,
        shift = {50, 50}
      }
    },
    essential = true,
    -- hidden = true,
    -- enabled = false,
    effects = {
      {
        type = "unlock-space-location",
        space_location = "nauvis",
        use_icon_overlay_constant = true
      }
    },
    prerequisites = {"space-platform-thruster"},
    unit = {
      count = 1000,
      ingredients =
      {
        {"automation-science-pack", 1},
        {"logistic-science-pack", 1},
        {"chemical-science-pack", 1},
        {"space-science-pack", 1}
      },
      time = 60
    }
  },
  {
    type = "technology",
    name = "calcite-trigger",
    icon = "__space-age__/graphics/technology/calcite-processing.png",
    icon_size = 256,
    effects = {
      { type = "unlock-recipe", recipe = "acid-neutralisation" },
      { type = "unlock-recipe", recipe = "steam-condensation" },
      { type = "unlock-recipe", recipe = "simple-coal-liquefaction" }
    },
    hidden = true,
    enabled = true,
    research_trigger = {
      type = "craft-item",
      item = "calcite"
    },
    prerequisites = { "fluid-handling" },
  }
})
