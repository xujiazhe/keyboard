-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

local send_return = false
local last_mods = {}

local ctrl_key_handler = function()
  send_return = false
end

local ctrl_key_timer = hs.timer.delayed.new(0.15, ctrl_key_handler)

local ctrl_handler = function(evt)
  --print("control handler", last_mods["ctrl"])
  local new_mods = evt:getFlags()
  if last_mods["ctrl"] == new_mods["ctrl"] then
    return false
  end
  if not last_mods["ctrl"] then
    last_mods = new_mods
    send_return = true
    ctrl_key_timer:start()
  else
    if send_return then
      keyUpDown({}, 'return')
    end
    last_mods = new_mods
    ctrl_key_timer:stop()
  end
  return false
end

local ctrl_tap = hs.eventtap.new({hs.eventtap.event.types.flagsChanged}, ctrl_handler)
ctrl_tap:start()

local other_handler = function(evt)
  --print("other handler")
  send_return = false
  return false
end

local other_tap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, other_handler)
other_tap:start()
