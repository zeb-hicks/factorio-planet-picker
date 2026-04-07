data.extend({
  {
    type = "bool-setting",
    name = "planet-picker-modify-fulgora-ruins",
    setting_type = "startup",
    default_value = true,
    order = "f[fulgora]-a"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-fulgora-ice",
    setting_type = "startup",
    default_value = true,
    order = "f[fulgora]-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-fulgora-sulfur",
    setting_type = "startup",
    default_value = true,
    order = "f[fulgora]-c"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-gleba-centrifugation",
    setting_type = "startup",
    default_value = true,
    order = "g[gleba]-a"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-gleba-landfill",
    setting_type = "startup",
    default_value = true,
    order = "g[gleba]-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-vulcanus-trees",
    setting_type = "startup",
    default_value = true,
    order = "v[vulcanus]-a"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-vulcanus-plastic",
    setting_type = "startup",
    default_value = true,
    order = "v[vulcanus]-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-vulcanus-generator",
    setting_type = "startup",
    default_value = true,
    order = "v[vulcanus]-c"
  },
  {
    type = "bool-setting",
    name = "planet-picker-modify-vulcanus-mining",
    setting_type = "startup",
    default_value = true,
    order = "v[vulcanus]-d"
  }
})

data.extend({
  {
    type = "bool-setting",
    name = "planet-picker-nauvis",
    setting_type = "runtime-global",
    default_value = true,
    order = "p[planet-picker]-a"
  },
  {
    type = "bool-setting",
    name = "planet-picker-gleba",
    setting_type = "runtime-global",
    default_value = true,
    order = "p[planet-picker]-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-fulgora",
    setting_type = "runtime-global",
    default_value = true,
    order = "p[planet-picker]-c"
  },
  {
    type = "bool-setting",
    name = "planet-picker-vulcanus",
    setting_type = "runtime-global",
    default_value = true,
    order = "p[planet-picker]-d"
  },
  {
    type = "bool-setting",
    name = "planet-picker-aquilo",
    setting_type = "runtime-global",
    default_value = false,
    order = "p[planet-picker]-e"
  },
})

data.extend({
  {
    type = "bool-setting",
    name = "planet-picker-modded-planets",
    setting_type = "runtime-global",
    default_value = false,
    order = "z-a"
  },
  {
    type = "bool-setting",
    name = "planet-picker-chat",
    setting_type = "runtime-global",
    default_value = true,
    order = "z-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-chat-see-other-forces",
    setting_type = "runtime-global",
    default_value = true,
    order = "z-b"
  },
  {
    type = "bool-setting",
    name = "planet-picker-chat-speak-other-forces",
    setting_type = "runtime-global",
    default_value = true,
    order = "z-b"
  },
  {
    type = "string-setting",
    name = "planet-picker-blacklist",
    setting_type = "startup",
    default_value = "",
    order = "z-z",
    allow_blank = true,
  },
})