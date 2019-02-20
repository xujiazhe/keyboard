-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

local send_down = false
local last_mods = {}

local cmd_key_handler = function()
  send_down = false
end

local cmd_key_timer = hs.timer.delayed.new(0.2, cmd_key_handler)

local cmd_handler = function(evt)
  --print("control handler", last_mods["ctrl"])
  local new_mods = evt:getFlags()
  if last_mods["cmd"] == new_mods["cmd"] then
    return false
  end
  if not last_mods["cmd"] then
    last_mods = new_mods
    send_down = true
    cmd_key_timer:start()
  else
    if send_down then
      keyUpDown({}, 'down')
    end
    last_mods = new_mods
    cmd_key_timer:stop()
  end
  return false
end

local cmd_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, cmd_handler)
cmd_tap:start()

local other_handler3 = function(evt)
  --print("other handler")
  send_down = false
  return false
end

local other3_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, other_handler3)
other3_tap:start()
