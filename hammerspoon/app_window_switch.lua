-- 程序和快捷键 的绑定
local log = hs.logger.new('app_window_switch.lua', 'debug')

--local application = require "hs.application"

local fn_app_key = {
    b = "Typora",
    D = 'Activity Monitor',
    v = "com.tencent.xinWeChat",
    k = "Karabiner-EventViewer",
    K = "Karabiner-Elements",
    l = "BetterAndBetter",
    w = 'automator',
    W = 'Evernote',

    c = 'Xcode',
    --c = 'Charles',
    q = "QQ",
    g = "Postman",

    ['1'] = "Hammerspoon",
    ['2'] = 'Reminders',
    ['3'] = 'Calendar',
    ['4'] = "Be Focused",

    --['`'] = "sourceTree",
    ['t'] = "Sequel Pro",
    ['x'] = "XMind",
    ['r'] = "redis",
    ['i'] = '脚本编辑器'
} -- abdvcqgtxr

local alt_app_key = {
    ['1'] = 'iTerm',
    ['!'] = "Terminal",
    ['2'] = 'IntelliJ IDEA',
    ['@'] = "Sublime Text",
    ['3'] = "ru.yandex.desktop.yandex-browser",
    ['#'] = 'Google Chrome',
    ['4'] = 'PyCharm',
    ['$'] = 'WebStorm',
    ['r'] = 'pdf expert',
    --['g'] = 'google chrome canary',

    f = 'Notes',
    F = 'Stickies',
    c = 'HandShaker',
    o = 'OpenSCAD',
    -- cC

    e = 'Finder',
    E = 'Microsoft Excel',
    --v = 'WeChat',
    b = "GitBook Editor",

    w = 'Microsoft Word',
    W = 'AliWangwang',
    m = 'Mail',
    M = 'Airmail 3',
    n = 'NeteaseMusic',
    N = '百度音乐',
    ['['] = 'App Store',
    [']'] = 'com.apple.iTunes',
    [';'] = 'com.apple.Photos',
    ['}'] = 'VLC',
    ['\''] = 'MPlayerX',
    --[''] = 'com.apple.SystemProfiler',
    [','] = 'com.apple.systempreferences',
    k = '迅雷'
}

hs.application.enableSpotlightForNameSearches(true);

local targetAppFocused = false  -- 上一个切换的程序 是 切进来了吗?
local targetAppWinCnt = 0
local hyperSwitchIdx = 0
local lastAppKey = ""

---toggleAppWins
---切换/启动 应用
---@param UIName string 名字
---@return boolean, number  改目标应用的窗口 是不是切进来了, 活跃的窗口数量是多少
local function toggleAppWins(Name)
    local uiName = getUIName(Name) or Name
    local startName = getStartName(uiName) or uiName
    local runningApp = hs.appfinder.appFromName(uiName) or hs.application.get(startName)
    log.f("uiName = %s", uiName)
    if not runningApp then
        log.f(' runningApp = %s, startName = %s, uiName = %s', hs.inspect(runningApp), startName, uiName)
        local hsapp = hs.application
        if hsapp.launchOrFocus(startName) or hsapp.launchOrFocusByBundleID(startName) then
            return true, 1
        end -- 虚拟机共享的软件
        return false, 0
    end

    local mainwin = runningApp:mainWindow()
    local winCnt = 0;
    hs.fnutils.each(runningApp:allWindows(), function(win)
        local oneShowableWindow = win:subrole() == "AXStandardWindow" and 1 or 0;
        winCnt = winCnt + oneShowableWindow;
    end)
    if mainwin then
        if mainwin == hs.window.focusedWindow() then
            mainwin:application():hide()
            return false, winCnt
        else
            mainwin:application():activate(true)
            mainwin:application():unhide()
            mainwin:focus()
            return true, winCnt
        end
    else
        hs.application.open(startName)
        return true, winCnt
    end
end

local isFnOrAltWithShift = "" -- modifier 组成范式  Fn/Alt + Shift?
local helpMsgTgCnt = 0
local appSwitchKeyTableHelp = ""

--1 摁下  0 抬起
local function flagUtil(flag, flagKey)
    local kmap = hs.keycodes.map

end
-- 根据modifier键 起落   给出通知是不是在状态
-- 除了shift不管   其他的cmd 都会直接改变状态
-- 右边的都标记非法直接破坏状态的
local function inHyperState(evt)
    local flags = evt:getFlags()
    local ckey = evt:getKeyCode()
    -- 符合  条件条件的时候 开启  主mod alt/fn
    -- 不符合 条件的时候 关闭  清理
    local kmap = hs.keycodes.map

    if not isFnOrAltWithShift(flags) then
        return false
    end

    if ckey ~= kmap.alt and ckey ~= kmap.fn and ckey ~=  kmap.shift then
        return ;
    end



    --isFnOrAltWithShift(flags)

end
---松开opt 或者 fn的效果
---中断连续切换的状态 保持fn or opt hold on 就是保持状态, 切换其他 都是中断状态 除了shift
---@param evt table
local flagsChangedHander = function(evt)
    local flags = evt:getFlags()
    local ckey = evt:getKeyCode()

    if not isFnOrAltWithShift(flags) then return false
    else end

    if ckey == hs.keycodes.map['shift'] then return end
    if hyperSwitchIdx == 0 then return end

    keyUpDown({}, 'escape')
    lastAppKey = {}
    targetAppFocused = false
    hyperSwitchIdx = 0

    return false
end


---fnOrAltCatcher 切换应用程序的捕捉  Fn alt  加上了shift. 后松shift
-- 功能:     摁下 单个的Fn/alt + 数字字母, 切换应用.   需要配合 HyperSwitch 只设置current app's windows
-- 状态轮转: 集体出来并激活焦点, 集体隐藏, 循环应用窗口.... 松开flag 就停止到相应的状态.
-- 比如chrome有3个窗口, 处于未激活状态: 摁住alt, 摁下 5 次 其AppKey
--     先chrome窗口集体出来, 消失, 然后开始循环窗口... 过程中, 松开alt就停止到相应的状态
--     有些符号自带 fn
---@param event function
local function fnOrAltCatcher(event)
    local flags = event:getFlags()

    if not isFnOrAltWithShift(flags) then
        return false
    end

    local targetAppKey = event:getCharacters(true)
    local keyCode = event:getKeyCode()
    if FnKeyCodeInRange(keyCode) then
        return false
    end

    log.f('\n\t\t targetAppFocused = %s, targetAppWinCnt = %s, lastAppKey = %s, hyperSwitchIdx = %d \n',
            targetAppFocused, targetAppWinCnt, hs.inspect(lastAppKey), hyperSwitchIdx)

    local appName = flags:contain({ "fn" }) and fn_app_key[targetAppKey] or
            flags:contain({ "alt" }) and alt_app_key[targetAppKey]
    if not appName then
        if targetAppKey == 'R' then
            hs.reload()
            return true, {}
        end
        if targetAppKey == '`' and flags:containExactly({ "fn" }) then
            if helpMsgTgCnt % 2 == 0 then
                appSwitchKeyTableHelp:show()
            else
                appSwitchKeyTableHelp:hide()
            end
            helpMsgTgCnt = helpMsgTgCnt + 1

            return true, {}
        end
        flagsChangedHander(event)
        return false
    end
    log.f("appName = '%s'", appName)

    if targetAppFocused and targetAppWinCnt > 1 then
        if targetAppKey == lastAppKey then
            if hyperSwitchIdx < targetAppWinCnt then
                hyperSwitchIdx = hyperSwitchIdx + 1
                return true, { hs.eventtap.event.newKeyEvent({ "alt" }, '`', true) } -- cmd + ` ok too
            else
                flagsChangedHander(event)
            end
        elseif lastAppKey ~= targetAppKey then
            flagsChangedHander(event)
            lastAppKey = targetAppKey
        end
    end

    targetAppFocused, targetAppWinCnt = toggleAppWins(appName)
    lastAppKey = targetAppKey
    return true, {}
end
--leftMouseDragged
local fnAltAppTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, fnOrAltCatcher)
fnAltAppTapper:start()

local flagTapper = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, flagsChangedHander)
flagTapper:start()


-- 进入状态了后 再摁原键
-- application watch 进入了状态  windows的属性 也得了解如果是设置窗口
local hyperSwitch = hs.appfinder.appFromName('com.bahoom.HyperSwitch')
local notInHyper = function()
    return (nil == hs.fnutils.find(hyperSwitch:allWindows(), function(win)
        if win:title() ~= "" then
            return false
        end
        if win:isStandard() then
            return false
        end
        if win:subrole() ~= "AXSystemDialog" then
            return false
        end
        return true
    end))
end

FnKeyCodeInRange = function(keyCode)
    -- 96 - 126 在ASCII键盘布局下 摁下好像都自带Fn  hs.keycodes.map[keyCode]  -- 除了 108 110 112
    -- eisu, kana, f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12, f13, f14, f15, f16, forwarddelete,
    -- help, home, end, pagedown, pageup, left, right, down, up
    if keyCode >= 96 and keyCode <= 126 then
        return true
    end
    return false
end
keyUpDown = function(modifiers, key)
    -- Un-comment & reload config to log each keystroke that we're triggering
    log.d('Sending keystroke:', hs.inspect(modifiers), key)
    hs.eventtap.keyStroke(modifiers, key, 0)
end

isFnOrAltWithShift = function(flags)
    local shiftOn = 0
    local mdfCnt = 0
    for _ in pairs(flags) do
        mdfCnt = mdfCnt + 1
    end
    if mdfCnt ~= 1 and mdfCnt ~= 2 then
        return false
    end  -- 1, 2
    if flags:contain({ "shift" }) then
        shiftOn = 1
    end

    if (mdfCnt - shiftOn) == 1 and (flags:contain({ "alt" }) or flags:contain({ "fn" })) then
        return mdfCnt
    else
        return false
    end
end

local message = require('keyboard.status-message')

local t = function()
    local helpContent = 'fn app\n'
    local cnt = 0
    for key, appName in pairs(fn_app_key) do
        cnt = cnt + 1
        if cnt % 4 == 0 then
            helpContent = helpContent .. '\n'
        end
        helpContent = helpContent .. string.format('%3s  %-21.18s', key, appName)
    end

    helpContent = helpContent .. '\n\nalt app\n'
    cnt = 0
    for key, appName in pairs(alt_app_key) do
        cnt = cnt + 1
        if cnt % 4 == 0 then
            helpContent = helpContent .. "\n"
        end
        helpContent = helpContent .. string.format('%3s  %-21.18s', key, appName)
    end

    local statusMessage = message.new(helpContent)
    return statusMessage
end
appSwitchKeyTableHelp = t()

return { endfnAltAppTapper = fnAltAppTapper, modifierDownHander = modifierDownHander }
