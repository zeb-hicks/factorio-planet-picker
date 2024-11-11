data.extend({
  {
    type = "item",
    name = "iron-carbide-powder",
    icons = {{
      icon = "__planet-picker__/graphics/icons/iron-carbide-powder.png",
      priority = "high",
      icon_size = 160,
      width = 160,
      height = 164,
    }},
    order = "a[smelting]-c[steel-plate-sintering]",
    subgroup = "raw-material",
    pick_sound = item_sounds and item_sounds.landfill_inventory_pickup,
    drop_sound = item_sounds and item_sounds.landfill_inventory_move,
    stack_size = 200,
    weight = 1000,
    random_tint_color = item_tints.iron_rust
  },
  {
    type = "item",
    name = "thermal-vent",
    subgroup = "energy",
    order = "a[heat-exchanger]-b[thermal-vent]",
    icons = {{
      icon = "__planet-picker__/graphics/icons/thermal-vent.png",
      priority = "high",
      icon_size = 512,
      width = 512,
      height = 512,
    }},
    stack_size = 10,
    weight = 100000,
    rocket_lift_weight = 100000,
    place_result = "thermal-vent"
  }
})
