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
  for k, v in pairs(table) do
    if v == key then
      return k
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

---Removes a technology from the tree, joining the dangling tree edges.
---@param name string
function extricate_technology(name)
  local ancestors = {}
  local descendants = {}
  -- Store the technologies above the target technology
  for _, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
      for i = #tech.prerequisites, 1, -1 do
        if tech.prerequisites[i] == name then
          table.insert(ancestors, tech.name)
          table.remove(tech.prerequisites, i)
        end
      end
    end
  end

  -- Store the technologies below the target technology
  if data.raw.technology[name].prerequisites then
    for i = #data.raw.technology[name].prerequisites, 1, -1 do
      table.insert(descendants, data.raw.technology[name].prerequisites[i])
    end
  end

  -- Remove the targe technology from the heirarchy
  data.raw.technology[name].prerequisites = nil

  -- Link the ancestors to the descendants
  for _, decendant in pairs(descendants) do
    for _, ancestor in pairs(ancestors) do
      table.insert(data.raw.technology[decendant].prerequisites, ancestor)
    end
  end
end

function hide_technology(name)
  data.raw.technology[name].hidden_in_factoriopedia = true
  data.raw.technology[name].hidden = true
end

function strip_dependants(name)
  for _, tech in pairs(data.raw.technology) do
    if tech.prerequisites then
      for i = #tech.prerequisites, 1, -1 do
        if tech.prerequisites[i] == name then
          table.remove(tech.prerequisites, i)
        end
      end
      if #tech.prerequisites == 0 then
        tech.prerequisites = nil
      end
    end
  end
end
