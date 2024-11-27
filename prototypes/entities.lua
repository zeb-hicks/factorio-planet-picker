require("utils.table")

if settings.startup["planet-picker-modify-vulcanus-generator"] then
  local vent = {
    type = "mining-drill",
    name = "thermal-vent",
    icon = "__planet-picker__/graphics/icons/thermal-vent.png",
    icon_size = 512,
    flags = {"placeable-neutral", "player-creation", "not-rotatable"},
    corpse = "big-remnants",
    minable = {mining_time = 1, result = "thermal-vent"},
    max_health = 300,

    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},

    fast_replaceable_group = "pumpjack",
    pictures = {
      layers = {{
        filename = "__planet-picker__/graphics/entities/thermal-vent.png",
        priority = "low",
        width = 512,
        height = 512,
        line_length = 12,
        shift = {0, 0},
        scale = 0.25,
      }}
    },

    graphics_set = {
      animation = {
        layers = {
          {
            filename = "__planet-picker__/graphics/entities/thermal-vent.png",
            priority = "low",
            width = 512,
            height = 512,
            line_length = 12,
            frame_count = 12,
            animation_speed = 1,
            direction_count = 1,
            shift = {0, 0},
            scale = 0.25,
          }
        }
      }
    },

    smoke = {{
      name = "smoke",
      north_position = {0.0, 0.0},
      east_position = {0.0, 0.0},
      frequency = 10,
      starting_vertical_speed = 0.08,
      slow_down_factor = 1,
      starting_frame_deviation = 60
    }},

    vector_to_place_result = {0, 0},

    energy_usage = "1kW",
    energy_source = {
      type = "void",
      usage_priority = "secondary-input",
    },
    mining_speed = 3,
    resource_categories = {"basic-fluid"},
    resource_searching_radius = 0.49,
    radius_visualisation_picture = {
      filename = "__base__/graphics/entity/pumpjack/pumpjack-radius-visualization.png",
      width = 12,
      height = 12
    },
    monitor_visualization_tint = {78, 173, 255},
  }

  ---@type data.ElectricEnergyInterfacePrototype
  local generator = {
    type = "electric-energy-interface",
    name = "thermal-vent-generator",
    icon = "__planet-picker__/graphics/icons/thermal-vent.png",
    icon_size = 512,
    collision_box = {{-1.2, -1.2}, {1.2, 1.2}},
    selection_box = nil,
    minable = nil,
    max_health = nil,

    allow_copy_paste = false,
    impact_category = "metal",
    is_military_target = false,

    energy_source = {
      type = "electric",
      buffer_capacity = "200kJ",
      usage_priority = "primary-output",
      input_flow_limit = "0kW",
      output_flow_limit = "200kW"
    },
    energy_production = "200kW",
    energy_usage = "0kW",
    working_sound = {
      sound = {
        filename = "__base__/sound/steam-turbine.ogg",
        volume = 0.49,
        speed_smoothing_window_size = 60,
        advanced_volume_control = {attenuation = "exponential"},
      },
      match_speed_to_activity = true,
      audible_distance_modifier = 0.8,
      max_sounds_per_type = 3,
      fade_in_ticks = 4,
      fade_out_ticks = 20
    },

    smoke = {{
      name = "smoke",
      north_position = {0.0, 0.0},
      east_position = {0.0, 0.0},
      frequency = 10,
      starting_vertical_speed = 0.08,
      slow_down_factor = 1,
      starting_frame_deviation = 60
    }},
  }

  data.extend({vent, generator})
end
