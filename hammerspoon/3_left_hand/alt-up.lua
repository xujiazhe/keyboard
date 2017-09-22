-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

local send_up = false
local last_mods = {}

local alt_key_handler = function()
  send_up = false
end

local alt_key_timer = hs.timer.delayed.new(0.2, alt_key_handler)

local alt_handler = function(evt)
  --print("control handler", last_mods["ctrl"])
  local new_mods = evt:getFlags()
  if last_mods["alt"] == new_mods["alt"] then
    return false
  end
  print("alt_handler for sth")
  if not last_mods["alt"] then
    last_mods = new_mods
    send_up = true
    alt_key_timer:start()
  else
    if send_up then
      keyUpDown({}, 'up')
    end
    last_mods = new_mods
    alt_key_timer:stop()
  end
  return false
end

local alt_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, alt_handler)
alt_tap:start()

local other_handler3 = function(evt)
  --print("other handler")
  send_up = false
  return false
end

local other3_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, other_handler3)
other3_tap:start()
