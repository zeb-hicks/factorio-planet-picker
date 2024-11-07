require("utils")

extricate_technology("oil-gathering")
hide_technology("oil-gathering")

hide_technology("planet-discovery-gleba")
hide_technology("planet-discovery-fulgora")
hide_technology("planet-discovery-vulcanus")

strip_dependants("planet-discovery-gleba")
strip_dependants("planet-discovery-fulgora")
strip_dependants("planet-discovery-vulcanus")

data.raw["technology"]["calcite-processing"].prerequisites = { "fluid-handling" }
remove_dependency("fluid-handling", "oil-gathering")

-- Add pumpjack to fluid handling technology
table.insert(data.raw["technology"]["fluid-handling"].effects, {type = "unlock-recipe", recipe = "pumpjack" })
table.insert(data.raw["technology"]["calcite-processing"].effects, {type = "unlock-recipe", recipe = "chemical-plant" })
table.insert(data.raw["technology"]["calcite-processing"].effects, {type = "unlock-recipe", recipe = "pumpjack" })

-- Add low probability to gather wood from carbonised trees
table.insert(data.raw["tree"]["ashland-lichen-tree"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.06 })
table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 1, probability = 0.14 })
table.insert(data.raw["tree"]["ashland-lichen-tree-flaming"].minable.results, { type = "item", name = "wood", amount = 2, probability = 0.03 })

table.insert(data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable.results, { type = "item", name = "substation", amount = 1, probability = 0.5 })
table.insert(data.raw["lightning-attractor"]["fulgoran-ruin-attractor"].minable.results, { type = "item", name = "lightning-rod", amount = 1, probability = 0.2 })
table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 1, probability = 0.66 })
table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 2, probability = 0.33 })
table.insert(data.raw["simple-entity"]["fulgoran-ruin-vault"].minable.results, { type = "item", name = "accumulator", amount = 3, probability = 0.1 })
table.insert(data.raw["simple-entity"]["fulgoran-ruin-colossal"].minable.results, { type = "item", name = "accumulator", amount = 1, probability = 0.5 })

-- hide_technology("calcite-processing")