---@param tech data.TechnologyPrototype
function add_technology(tech)
  data.raw.technology[tech.name] = tech
end

---@param tech string
---@param prerequisites string[]
function set_prerequisites(tech, prerequisites)
  for _, technology in pairs(data.raw["technology"][tech]) do
    technology.prerequisites = prerequisites
  end
end

---@param tech string
---@param prerequisites string[]
function add_prerequisites(tech, prerequisites)
  for _, technology in pairs(data.raw["technology"][tech]) do
    for _, prerequisite in pairs(prerequisites) do
      table.insert(technology.prerequisites, prerequisite)
    end
  end
end

---@param tech string
---@param trigger data.TechnologyTrigger
function set_trigger(tech, trigger)
  data.raw.technology[tech].research_trigger = trigger
  data.raw.technology[tech].unit = nil
end

---@param tech string
---@param unit data.TechnologyUnit
function set_unit(tech, unit)
  data.raw.technology[tech].unit = unit
  data.raw.technology[tech].research_trigger = nil
end

---@param tech string
---@param effects data.Modifier[]
function add_effects(tech, effects)
  for _, effect in pairs(effects) do
    table.insert(data.raw.technology[tech].effects, effect)
  end
end

---@param recipes data.RecipePrototype
function add_recipes(recipes)
  for _, r in recipes do
    data.raw.recipe[r.name] = r
  end
end

---@param recipes string[]
function remove_recipes(recipes)
  for _, recipe in pairs(recipes) do
    data.raw["recipe"][recipe] = nil
  end
end

function find_in(table, key)
  if type(key) == "string" then
    for k, v in pairs(table) do
      if k == key then
        return v
      end
    end
  end
  if type(key) == "table" then
    for k, v in pairs(table) do
      if v == key then
        return k
      end
    end
  end
  if type(key) == "table" then
    for k, v in pairs(table) do
      local a, b = 0, 0
      for k2, v2 in pairs(key) do
        a = a + 1
        if v[k2] == v2 then
          b = b + 1
        end
      end
      if a == b and a > 0 then
        return k
      end
    end
  end
  return nil
end

function remove_dependency(tech, dependency)
  local tech = data.raw.technology[tech]
  local index = find_in(tech.prerequisites, dependency)
  if index then
    table.remove(tech.prerequisites, index)
  end
end

function remove_from_descendants(name)
  local descendants = {}
  for _, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
      for i = #tech.prerequisites, 1, -1 do
        if tech.prerequisites[i] == name then
          table.insert(descendants, tech.name)
          table.remove(tech.prerequisites, i)
        end
      end
    end
  end
  return descendants
end

function remove_prerequisites(name)
  local ancestors = {}
  if data.raw.technology[name].prerequisites then
    for i = #data.raw.technology[name].prerequisites, 1, -1 do
      local prerequisite = data.raw.technology[name].prerequisites[i]
      table.insert(ancestors, prerequisite)
      table.remove(data.raw.technology[name].prerequisites, i)
    end
  end
  return ancestors
end

---Removes a technology from the tree, joining the dangling tree edges.
---@param name string
function extricate_technology(name)
  -- Store the technologies that refer to the target technology as a prerequisite
  local descendants = remove_from_descendants(name)
  -- Store the technologies above the target technology
  local ancestors = remove_prerequisites(name)

  -- Remove the targe technology from the heirarchy
  data.raw.technology[name].prerequisites = nil

  -- Link the ancestors to the descendants
  for _, descendant in pairs(descendants) do
    for _, ancestor in pairs(ancestors) do
      table.insert(data.raw.technology[descendant].prerequisites, ancestor)
    end
  end
end

function hide_technology(name)
  data.raw.technology[name].hidden_in_factoriopedia = true
  data.raw.technology[name].hidden = true
end

function transfer_effects(from, to)
  local from = data.raw.technology[from]
  local to = data.raw.technology[to]
  if from and to then
    for _, effect in pairs(from.effects) do
      table.insert(to.effects, effect)
    end
  end
end

function unlock_planet_technology(force, surface)
  local name = "planet-discovery-"..surface.name
  local tech = force.technologies[name]
  if tech then tech.researched = true end
end

function nil_chain(table, ...)
  local value = table
  for _, key in pairs({...}) do
    if value[key] then
      value = value[key]
    else
      return nil
    end
  end
  return value
end

---@param player LuaPlayer
function collect_items_from(player)
  local items = {}
  if not player then return items end

  local main = player.get_inventory(defines.inventory.character_main)
  local guns = player.get_inventory(defines.inventory.character_guns)
  local ammo = player.get_inventory(defines.inventory.character_ammo)
  local armor = player.get_inventory(defines.inventory.character_armor)
  local trash = player.get_inventory(defines.inventory.character_trash)

  if main then for _, item in pairs(main and main.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_main }) end end
  if guns then for _, item in pairs(guns and guns.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_guns }) end end
  if ammo then for _, item in pairs(ammo and ammo.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_ammo }) end end
  if armor then for _, item in pairs(armor and armor.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_armor }) end end
  if trash then for _, item in pairs(trash and trash.get_contents()) do table.insert(items, { item = item, inventory = defines.inventory.character_trash }) end end

  return items
end

function dlog(message)
  local nimph_present = game.players["Nimphious"] and true or false
  if nimph_present then
    log(message)
  end
end