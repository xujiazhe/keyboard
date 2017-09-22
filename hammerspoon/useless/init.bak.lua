local log = hs.logger.new('init.lua', 'debug')

-- Use Control+` to reload Hammerspoon config
keyUpDown = function(modifiers, key)
  -- Un-comment & reload config to log each keystroke that we're triggering
  -- log.d('Sending keystroke:', hs.inspect(modifiers), key)

  hs.eventtap.keyStroke(modifiers, key, 0)
end

-- Subscribe to the necessary events on the given window filter such that the
-- given hotkey is enabled for windows that match the window filter and disabled
-- for windows that don't match the window filter.
--
-- windowFilter - An hs.window.filter object describing the windows for which
--                the hotkey should be enabled.
-- hotkey       - The hs.hotkey object to enable/disable.
--
-- Returns nothing.
enableHotkeyForWindowsMatchingFilter = function(windowFilter, hotkey)
  windowFilter:subscribe(hs.window.filter.windowFocused, function()
    hotkey:enable()
  end)

  windowFilter:subscribe(hs.window.filter.windowUnfocused, function()
    hotkey:disable()
  end)
end


require('keyboard.control-escape')
require('keyboard.4_terminal.delete-words')
require('keyboard.hyper')
require('keyboard.markdown')
require('keyboard.microphone')
require('keyboard.4_terminal.iterm2_panes')
require('keyboard.5_right_hand')
require('keyboard.windows_ops')

hs.notify.new({title='Hammerspoon', informativeText='Ready to rock 🤘'}):send()


,

-- Use control + h/j/k/l to move left/down/up/right by one pane
{
from = { { 'ctrl' }, 'h' },
to = { { 'cmd', 'alt' }, 'left' }
},
{
from = { { 'ctrl' }, 'j' },
to = { { 'cmd', 'alt' }, 'down' }
},
{
from = { { 'ctrl' }, 'k' },
to = { { 'cmd', 'alt' }, 'up' }
},
{
from = { { 'ctrl' }, 'l' },
to = { { 'cmd', 'alt' }, 'right' }
},
