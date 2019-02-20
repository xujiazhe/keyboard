local log = hs.logger.new('init.lua', 'debug')



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
require("keyboard.app_name")

keyUpDown = function(modifiers, key)
    -- Un-comment & reload config to log each keystroke that we're triggering
     log.d('Sending keystroke:', hs.inspect(modifiers), key)
    hs.eventtap.keyStroke(modifiers, key, 0)
end

FnKeyCodeInRange = function (keyCode)
    -- 96 - 126 在ASCII键盘布局下 摁下好像都自带Fn  hs.keycodes.map[keyCode]  -- 除了 108 110 112
    -- eisu, kana, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, forwarddelete,
    -- help, home, end, pagedown, pageup, left, right, down, up
    if keyCode >= 96 and keyCode <= 126 then
        return true
    end
    return false
end
--require('keyboard.3_left_hand.ctrl-enter')
--require('keyboard.3_left_hand.alt-up')
--require('keyboard.3_left_hand.cmd-down')
require('keyboard.app_spec_fn')

require("keyboard.app_launch_key")
require('keyboard.windows_ops')
require('keyboard.system_func')

function timeReminder()
    -- keyUpDown({ 'alt', 'shift' }, 'C')
    -- keyUpDown({ 'alt' }, 'C')
    keyUpDown({ 'fn' }, '3')
    keyUpDown({ 'fn' }, '2')
    hs.alert("不跑偏 抓重点¡!")
    hs.timer.doAfter(1 * 30 * 60, timeReminder)
end
hs.timer.doAfter(1 * 30 * 60, timeReminder)
--require("keyboard.clipboard")
--require('keyboard.5_right_hand')


ins = hs.inspect
-- 延时执行函数, 并切换到响应窗口
function fn()
    local his = hs.console.getHistory()
    local statement = his[#his]
    --f = loadstring(statement)
    --print f
end
go = hs.timer.doAfter



--hs.fnutils.each(hs.application.runningApplications(), function(app) print(app:title()) end)

