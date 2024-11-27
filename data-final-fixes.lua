require("utils")

if settings.startup["planet-picker-modify-vulcanus-generator"]
or settings.startup["planet-picker-modify-vulcanus-plastic"]
or settings.startup["planet-picker-modify-fulgora-ice"]
or settings.startup["planet-picker-modify-fulgora-sulfur"] then
  transfer_effects("oil-gathering", "fluid-handling")
  transfer_effects("oil-processing", "fluid-handling")
  extricate_technology("oil-gathering")
  extricate_technology("oil-processing")
  hide_technology("oil-gathering")
  hide_technology("oil-processing")

  data.raw["technology"]["calcite-processing"].prerequisites = { "fluid-handling" }
end

if settings.startup["planet-picker-modify-fulgora-sulfur"] then
  table.insert(data.raw["recipe"]["battery-recycling"].results, { type = "item", name = "sulfur", amount = 1, probability = 0.125 })
end

if settings.startup["planet-picker-modify-vulcanus-plastic"] then
  table.insert(data.raw["technology"]["plastics"].effects, {type = "unlock-recipe", recipe = "polymer-dissolution" })
end

if settings.startup["planet-picker-modify-gleba-centrifugation"] then
  table.insert(data.raw["technology"]["bacteria-cultivation"].effects, {type = "unlock-recipe", recipe = "coal-centrifugation" })
  table.insert(data.raw["technology"]["bacteria-cultivation"].effects, {type = "unlock-recipe", recipe = "calcite-centrifugation" })
  -- table.insert(data.raw["technology"]["foundry"].prerequisites, "calcite-trigger")
end
if settings.startup["planet-picker-modify-gleba-landfill"] then
  table.insert(data.raw["technology"]["biochamber"].effects, {type = "unlock-recipe", recipe = "landfill" })
end

if settings.startup["planet-picker-modify-vulcanus-trees"] then
  table.insert(data.raw["tree"]["ashland-lichen-tree"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.12 })
  table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.16 })
  table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 2, probability = 0.8 })
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
