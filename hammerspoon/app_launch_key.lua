-- 程序和快捷键 的绑定
local log = hs.logger.new('app_launch_key.lua', 'debug')

--local application = require "hs.application"

local fn_app_key = {
    a = "Sublime Text",
    b = "Typora",
    B = "GitBook Editor",
    v = "钉钉",

    q = "QQ",
    g = "Postman",

    ['1'] = "Be Focused",
    ['2'] = "Reminders",
    ['3'] = "日历",
    ['4'] = "Hammerspoon",
    ['`'] = "屏幕共享",
    ['t'] = "Sequel Pro",
    ['x'] = "XMind",
    ['r'] = "redis"
}

local alt_app_key = {
    ['1'] = 'iTerm',
    ['!'] = "Terminal",
    ['2'] = 'IntelliJ IDEA',
    ['@'] = "Atom",
    ['3'] = 'Google Chrome',
    ['#'] = 'Safari',
    ['4'] = 'PyCharm',
    ['$'] = 'DataGrip',
    ['r'] = '预览',

    f = 'Notes',
    e = 'Finder',
    E = 'Microsoft Excel',
    v = '微信',

    D = 'Activity Monitor',

    w = 'Microsoft Word',
    W = 'AliWangwang',
    m = 'Mail',
    M = 'Airmail 3',
    n = 'NeteaseMusic',
    N = '百度音乐',
    ['['] = 'App Store',
    [']'] = 'iTunes音乐',
    [';'] = 'Photos',
    ['\''] = 'MPlayerX',
    [','] = '系统偏好设置',
    c = 'Charles',
    k = '迅雷'
}


local laptop_apps = {} --{ "钉钉", "微信" }
hs.application.enableSpotlightForNameSearches(true);

-- 进入状态了后 再摁原键
--
--
local in_mac_pro = hs.host.localizedName() == 'xjziMac'

local targetAppToggleIn = false  -- 上一个切换的程序 是 切进来了吗?
local focusedAppWinCnt = 0
local last_app_key = ""
local hyper_trans = false

---toggleApp
---切换应用
---@param targetAppName string 名字
---@return boolean, number  改目标应用的窗口 是不是切进来了, 活跃的窗口数量是多少
local function toggleApp(targetAppName)
    local switch_name = switchName(targetAppName)

    local app_a = hs.appfinder.appFromName(targetAppName)
    local app_b = hs.application.get(switch_name)
    local running_app = app_a or app_b

    if not running_app then
        hs.application.launchOrFocus(targetAppName)
        if switch_name then
            hs.application.launchOrFocus(switch_name)
        end
        -- hs.application.open(_name)
        -- if tname then hs.application.open(tname) end
        return true, 1
    end

    local mainwin = running_app:mainWindow()
    local wins = running_app:allWindows()

    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
            return false, #wins
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
            return true, #wins
        end
    else
        hs.application.open(targetAppName)
        if switch_name then
            hs.application.open(switch_name)
        end
        return true, #wins
        -- application.launchOrFocus(tname)
    end
end


local function fnOrAltCatcher(event)
    --local keycode = event:getKeyCode()
    local flags = event:getFlags()

    if not flags then return false end
    if not flags:contain({ "alt" }) and not flags:contain({ "fn" }) then return false end
    if flags:contain({ "alt", "fn" }) then return false end
    if flags:contain({ 'cmd' }) or flags:contain({ 'ctrl' }) then return false end

    local ckey = event:getCharacters(true)
    local keyCode = event:getKeyCode()

    if FnKeyCodeJumpRange(keyCode) then return false end

    if targetAppToggleIn and focusedAppWinCnt > 1 then
        if last_app_key == ckey then
            hyper_trans = true
            return true, { hs.eventtap.event.newKeyEvent({ "alt" }, '`', true) }
        elseif last_app_key ~= ckey then
            keyUpDown({}, 'escape')
            last_app_key = ckey
            hyper_trans = false
        end
        --event:setKeyCode(hs.keycodes.map['`'])
        --event:setFlags({ "alt" })
        --local keycode = event:getKeyCode()
        --print("keycode = ", keycode)
        --keyUpDown({ "alt"}, '`')
        --return true, {}
        --return false
    end

    local appName = flags:contain({ "fn" }) and fn_app_key[ckey] or flags:contain({ "alt" }) and alt_app_key[ckey]
    if in_mac_pro and hs.fnutils.contains(laptop_apps, appName) then
        --fn_alt_tapper.left_modifier =
        targetAppToggleIn, focusedAppWinCnt = toggleApp("屏幕共享")
        --keyUpDown({}, 'escape')4
        --hs.eventtap.event.newKeyEvent({ 'fn' }, '`', true):post()
        return true, {}
    end

    if appName then
        targetAppToggleIn, focusedAppWinCnt = toggleApp(appName)
        last_app_key = ckey
        return true, {}
    end

    if ckey == 'R' then hs.reload() end
    return false
end

local fnAltAppTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, fnOrAltCatcher)
fnAltAppTapper:start()


local modifierDownHander = function(evt)
    local flags = evt:getFlags()
    last_app_key = {}
    targetAppToggleIn = false
    hyper_trans = false
    return false
end

local modifierTapper = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, modifierDownHander)
modifierTapper:start()



--local left_modifier = nil
--local left_key = nil
local message = require('keyboard.status-message')

local function t()
    local helpContent = 'fn app\n'
    for key, appName in pairs(fn_app_key) do
        helpContent = helpContent .. "\n " .. key .. "  " .. appName
    end
    helpContent = helpContent .. '\n\nalt app'
    for key, appName in pairs(alt_app_key) do
        helpContent = helpContent .. "\n " .. key .. "  " .. appName
    end
    local statusMessage = message.new(helpContent)
    return statusMessage
end
local statusMessage = t()


return fnAltAppTapper
