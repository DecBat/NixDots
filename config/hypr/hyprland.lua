require("monitors")
require("keybinds")
require("windowrules")
require("autostart")

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    ["col.active_border"] = "rgba(ffffffcc)",
    layout = "dwindle",
  },
  decoration = {
    rounding = 10,
    blur = { enabled = true, size = 3, passes = 1 },
  },
  input = {
    kb_layout = "us",
    follow_mouse = 1,
    touchpad = { natural_scroll = true },
  },
})