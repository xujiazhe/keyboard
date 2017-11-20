local hk = require "hs.hotkey"

local alk = require("keyboard.app_launch_key")
local fnAltAppTapper = alk.fnAltAppTapper
local modifierDownHander = alk.modifierDownHander
local windowFuncTapper = require('keyboard.windows_ops')
local function modifierFuncBind(flags, keyFuncTable)
    for key, fn in pairs(keyFuncTable) do
        hk.bind(flags, key, fn)
    end
end

--modifierFuncBind({ 'alt', 'shfit' }, { L = function()
--    hs.caffeinate.startScreensaver()
--end })

local lookuptable = {
    [hs.application.watcher.activated] = 1,
    [hs.application.watcher.launched] = 1,
    [hs.application.watcher.launching] = 1,
    [hs.application.watcher.unhidden] = 1,

    [hs.application.watcher.terminated] = 0,
    [hs.application.watcher.hidden] = 0,
    [hs.application.watcher.deactivated] = 0
}

---applicationWatcher
---
---@param appName string
---@param eventType boolean
---@param appObject object
function applicationWatcher(appName, eventType, appObject)
    --modifierDownHander()
    APPNAME = "Screen Sharing"
    --APPNAME = "Finder"
    tappName = switchName(appName)
    if appName ~= APPNAME and tappName ~= APPNAME then
        return
    end

    if lookuptable[eventType] == 1 then
        fnAltAppTapper:stop()
        windowFuncTapper:stop()
    elseif lookuptable[eventType] == 0 then
        fnAltAppTapper:start();
        windowFuncTapper:start();
    end
end

local appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()

-- 左右点按 bn
-- elseif key == "b" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.leftClick(currentpos) }
-- elseif key == "n" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.rightClick(currentpos) }

