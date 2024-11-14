data.extend({
  {
    type = "recipe",
    name = "thermal-vent",
    category = "crafting",
    enabled = false,
    energy_required = 4.0,
    ingredients = {
      { type = "item", name = "iron-plate", amount = 12 },
      { type = "item", name = "copper-cable", amount = 24 },
      { type = "item", name = "iron-gear-wheel", amount = 16 }
    },
    results = {
      { type = "item", name = "thermal-vent", amount = 1 }
    }
  },
  {
    type = "recipe",
    name = "polymer-dissolution",
    subgroup = "vulcanus-processes",
    icons = {
      {
        icon = "__base__/graphics/icons/plastic-bar.png",
        icon_size = 64,
        scale = 0.8,
        shift = { -4, -4 }
      },
      {
        icon = "__base__/graphics/icons/fluid/heavy-oil.png",
        icon_size = 64,
        scale = 0.5,
        shift = { -16, -16 }
      }
    },
    category = "chemistry",
    enabled = false,
    energy_required = 12.0,
    ingredients = {
      { type = "fluid", name = "heavy-oil", amount = 400 },
      { type = "item", name = "carbon", amount = 20 }
    },
    results = {
      { type = "fluid", name = "steam", amount = 100, temperature = 500 },
      { type = "item", name = "plastic-bar", amount = 40 }
    }
  },
  {
    type = "recipe",
    name = "coal-centrifugation",
    icons = {
      {
        icon = "__base__/graphics/icons/coal.png",
        icon_size = 64,
        scale = 0.75,
        shift = { 0, -4 }
      },
      {
        icon = "__space-age__/graphics/icons/iron-bacteria.png",
        icon_size = 64,
        scale = 0.5,
        shift = { -12, 12 }
      },
      {
        icon = "__base__/graphics/icons/fluid/water.png",
        icon_size = 64,
        scale = 0.5,
        shift = { 12, 12 }
      }
    },
    category = "chemistry",
    subgroup = "agriculture-processes",
    enabled = false,
    energy_required = 2.0,
    ingredients = {
      { type = "fluid", name = "water", amount = 600 },
      { type = "item", name = "iron-bacteria", amount = 5 }
    },
    results = {
      { type = "fluid", name = "water", amount = 750 },
      { type = "item", name = "coal", amount = 2 }
    }
  },
  {
    type = "recipe",
    name = "calcite-centrifugation",
    icons = {
      {
        icon = "__space-age__/graphics/icons/calcite.png",
        icon_size = 64,
        scale = 0.75,
        shift = { 0, -4 }
      },
      {
        icon = "__space-age__/graphics/icons/copper-bacteria.png",
        icon_size = 64,
        scale = 0.5,
        shift = { -12, 12 }
      },
      {
        icon = "__base__/graphics/icons/fluid/water.png",
        icon_size = 64,
        scale = 0.5,
        shift = { 12, 12 }
      }
    },
    category = "chemistry",
    subgroup = "agriculture-processes",
    enabled = false,
    energy_required = 4.0,
    ingredients = {
      { type = "fluid", name = "water", amount = 1000 },
      { type = "item", name = "copper-bacteria", amount = 20 }
    },
    results = {
      { type = "fluid", name = "water", amount = 1500 },
      { type = "item", name = "calcite", amount = 1 }
    }
  },
})
