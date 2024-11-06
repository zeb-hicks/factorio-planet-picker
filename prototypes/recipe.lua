data.extend({
  {
    type = "recipe",
    name = "iron-carbide-powder",
    category = "crafting",
    subgroup = "raw-material",
    enabled = false,
    energy_required = 4.0,
    ingredients = {
      { type = "item", name = "iron-plate", amount = 4 },
      { type = "item", name = "carbon", amount = 2 },
    },
    results = {
      { type = "item", name = "iron-carbide-powder", amount = 1 },
    }
  },
  {
    type = "recipe",
    name = "carbon-steel",
    category = "smelting",
    subgroup = "raw-material",
    enabled = false,
    energy_required = 8.0,
    ingredients = {
      { type = "item", name = "iron-carbide-powder", amount = 1 },
    },
    results = {
      { type = "item", name = "steel-plate", amount = 1 },
    }
  },
  {
    type = "recipe",
    name = "thermal-vent",
    category = "crafting",
    enabled = false,
    energy_required = 2.0,
    ingredients = {
      { type = "item", name = "steel-plate", amount = 10 },
      { type = "item", name = "copper-cable", amount = 25 },
      { type = "item", name = "iron-gear-wheel", amount = 8 }
    },
    results = {
      { type = "item", name = "thermal-vent", amount = 1 }
    }
  }
})
