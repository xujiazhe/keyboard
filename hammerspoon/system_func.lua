local hk = require "hs.hotkey"

local fnAltAppTapper = require("keyboard.app_launch_key")
local windowFuncTapper = require('keyboard.windows_ops')
local function modifierFuncBind(flags, keyFuncTable)
    for key, fn in pairs(keyFuncTable) do
        hk.bind(flags, key, fn)
    end
end

--modifierFuncBind({ 'alt', 'shfit' }, { L = function()
--    hs.caffeinate.startScreensaver()
--end })


function applicationWatcher(appName, eventType, appObject)
    APPNAME = "Screen Sharing"
    --APPNAME = "Finder"
    tappName = switchName(appName)
    if appName ~= APPNAME and tappName ~= APPNAME then
        return
    end
    local lookuptable = {
        [hs.application.watcher.activated] = 1,
        [hs.application.watcher.launched] = 1,
        [hs.application.watcher.launching] = 1,
        [hs.application.watcher.unhidden] = 1,

        [hs.application.watcher.terminated] = 0,
        [hs.application.watcher.hidden] = 0,
        [hs.application.watcher.deactivated] = 0
    }

    if lookuptable[eventType] == 1 then
        -- appObject:selectMenuItem({"Window", "Bring All to Front"})
        fnAltAppTapper:stop()
        windowFuncTapper:stop()
        --if left_modifier then
        --hs.timer.usleep(500)
        --print("applicationWatcher ", left_modifier[0], left_key)
        --hs.timer.usleep(500)
        --hs.eventtap.event.newKeyEvent({}, "v", true):setFlags({"alt"}):post()
        --hs.eventtap.event.newKeyEvent({}, "v", false):setKeyCode(61):post()
        --hs.eventtap.event.newKeyEvent( { 'alt' }, left_key, true):post()
        --left_modifier = nil
        --left_key = nil
        --end
    elseif lookuptable[eventType] == 0 then
        --hs.eventtap.event.newKeyEvent( { 'ctrl' }, "left", true):post()
        --local a = hs.window.focusedWindow().focusWindowEast();
        fnAltAppTapper:start();
        windowFuncTapper:start();
    end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

--elseif key == '/' then
--return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) }
--elseif key == '\\' then
--return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) }
--end



-- 左右点按 bn
-- elseif key == "b" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.leftClick(currentpos) }
-- elseif key == "n" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.rightClick(currentpos) }

