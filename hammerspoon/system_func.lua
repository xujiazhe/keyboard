local hk = require "hs.hotkey"

local alk = require("keyboard.app_window_switch")
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

--hs.window.filter.default:subscribe(hs.window.filter.windowDestroyed, function(window, appName)
    --print("             ", window:title())
    --print(i({
    --    title   = window:title(),
    --    app     = window:application():name(),
    --    role    = window:role(),
    --    subrole = window:subrole()
    --}))
--end)

hs.window.filter.default:subscribe(hs.window.filter.windowFocused, function(window, appName)
    local mousepoint = hs.mouse.getAbsolutePosition()
    local winRect = window:frame()
    if winRect.x <= mousepoint.x and mousepoint.x <= winRect.x+winRect.w and
            winRect.y <= mousepoint.y and mousepoint.y <= winRect.y+winRect.h then
        return
    end
    local winCentrePoint = hs.geometry.point(winRect.x + winRect.w/2, winRect.y + winRect.h/2)
    hs.mouse.setAbsolutePosition(winCentrePoint)

    --local color = { red = 255 / 255, green = 77 / 255, blue = 61 / 255, alpha = 1 }
    --local circle = hs.drawing.circle(hs.geometry.rect(winCentrePoint.x-15, winCentrePoint.y-15, 30, 30))
    --circle:setFillColor(color):setFill(true):setStrokeWidth(1):setLevel(hs.drawing.windowLevels.overlay):setStrokeColor(hs.drawing.color.white)
    --circle:bringToFront(true)
    --circle:show(0.15)

    --local timer = hs.timer.doAfter(0.2, function()
    --    circle:hide(0.15)
    --    hs.timer.doAfter(0.2, function() circle:delete() end)
    --end)
end)
---applicationWatcher
---
---@param UIName string
---@param eventType boolean
---@param appObject object
function applicationWatcher(UIName, eventType, appObject)
    --modifierDownHander()
    APPNAME = "Screen Sharing"
    APPNAME2 = "parallels Desktop"

    --APPNAME = "Finder"
    -- hs.fnutils.contains
    startName = getStartName(UIName)
    if UIName ~= APPNAME and startName ~= APPNAME then
        return
    end
    if UIName ~= APPNAME2 and startName ~= APPNAME2 then
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

return appWatcher
-- 左右点按 bn
-- elseif key == "b" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.leftClick(currentpos) }
-- elseif key == "n" then
--     local currentpos = hs.mouse.getRelativePosition()
--     return true, { hs.eventtap.rightClick(currentpos) }

