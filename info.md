Allows players to select a planet to start on **individually** with an interface for selecting your starter planet.

Players are not seperated onto different forces, and are not forced to land in the same place. Play multiplayer in parallel on multiple planets!

Technologies and recipes have been altered slightly so that it is possible to start on all four inner planets without any assistance.

# Features and Changes

All changes to the vanilla game can be disabled (in startup mod settings)

### Modded Planets

Planet Picker can automatically detect modded planets and add them to the list. This setting is **off by default** for the same reason as Aquilo start: there is no guarantee that modded planets make it possible to start there.

If you want to use an unsupported modded planet, enable the mod setting to select modded planets.

![Settings](https://i.imgur.com/YW4qbOE.png)

Mod authors can use the provided remote interface to add their planet to the GUI by default.

The remote interface exposes a function `add_planet(name, callback)` where you provide the name of the planet (which should be identical to the planet's name in the game planet table) and a callback function with the signature `callback(player: LuaPlayer, first: bool)`

```lua
function earth_setup(player, first)
  for _, force in pairs(game.forces) do
    force.technologies["flint-knapping"].enabled = true
  end
end

remote.call("planet-picker", "add_planet", "earth", earth_setup)
```

### Technology
 - Fluid handling now unlocks the chemical plant and refinery, which make it possible to automate things without excessive tech tree changes for planets without resource patches on which to place pumpjacks.

### Nauvis
 - Adds a technology to discover Nauvis as you do the other planets.

### Vulcanus
 - Adds a very low chance for Vulcanus trees to drop wood so you can craft small electric poles prior to researching Energy Distribution 2.
 - Acid vent generator to produce a small amount of geothermal power directly from the acid vents on Vulcanus to enable initial power generation without a water source.
 - Add *Acid processing* technology to move the coal liquefaction technology so that it's possible to process oil on Vulcanus as a prerequisite to producing chemical science.
 - Reduce the mining hardness of rocks on Vulcanus to make early game resource gathering less painful.

### Fulgora
 - Adds various new low probability drops from several of the larger Fulgoran ruins for substations, medium poles, and accumulators.
 - Adds a very low chance mining Fulgoran Lighting Attractors will yield Lightning Rods so you can collect electricity at the cost of sacrificing some protection from the lightning storm.
 - New ice melting recipe for early water.
 - Low chance to recover sulfur from batteries.

### Gleba
 - Coal centrifugation recipe for pulling early coal out of bacteria in a chemical plant to facilitate military research.
 - Unlocks the landfill recipe when Biochambers are researched.

### Aquilo
There is no real way to get started on Aquilo without a source of iron or copper. The ability to start here is disabled by default, but you can enable it in the map settings so you can combine this with another mod overhauling Aquilo to make it possible to start there.