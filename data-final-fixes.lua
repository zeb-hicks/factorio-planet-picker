require("utils")

if settings.startup["planet-picker-modify-vulcanus-generator"]
or settings.startup["planet-picker-modify-fulgora-ice"] then
  transfer_effects("oil-gathering", "fluid-handling")
  transfer_effects("oil-processing", "fluid-handling")
  extricate_technology("oil-gathering")
  extricate_technology("oil-processing")
  hide_technology("oil-gathering")
  hide_technology("oil-processing")

  data.raw["technology"]["calcite-processing"].prerequisites = { "fluid-handling" }
end

if settings.startup["planet-picker-modify-fulgora-sulfur"] then
  -- Add chance to get sulfur from recycling batteries
  table.insert(data.raw["recipe"]["battery-recycling"].results, { type = "item", name = "sulfur", amount = 1, probability = 0.125 })
end

if settings.startup["planet-picker-modify-vulcanus-plastic"] then
  -- Add some kind of recipe for getting plastic on vulcanus
  -- Carbon + Steam?
  table.insert(data.raw["technology"]["plastics"].effects, {type = "unlock-recipe", recipe = "polymer-dissolution" })
end

if settings.startup["planet-picker-modify-gleba-grenades"] then
  -- Add a way to make coal on gleba
  table.insert(data.raw["technology"]["military-2"].effects, {type = "unlock-recipe", recipe = "spin-bio-seperation" })
end

-- Add low probability to gather wood from carbonised trees
if settings.startup["planet-picker-modify-vulcanus-trees"] then
  table.insert(data.raw["tree"]["ashland-lichen-tree"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.06 })
  table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.14 })
  table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 2, probability = 0.03 })
end

if settings.startup["planet-picker-modify-fulgora-ruins"] then
  table.insert(data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable.results, { type = "item", name = "substation", amount = 1, probability = 0.5 })
  table.insert(data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable.results, { type = "item", name = "lightning-rod", amount = 1, probability = 0.2 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 1, probability = 0.66 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 2, probability = 0.33 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 3, probability = 0.1 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-colossal"].minable.results, { type = "item", name = "accumulator", amount = 1, probability = 0.5 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-huge"].minable.results, { type = "item", name = "accumulator", amount = 1, probability = 0.3 })
  table.insert(data.raw["simple-entity"]["fulgoran-ruin-huge"].minable.results, { type = "item", name = "medium-electric-pole", amount = 1, probability = 0.5 })
end

if settings.startup["planet-picker-modify-fulgora-ice"] then
  table.insert(data.raw["technology"]["fluid-handling"].effects, {type = "unlock-recipe", recipe = "ice-melting" })
end
