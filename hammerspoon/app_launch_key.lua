-- 程序和快捷键 的绑定
local log = hs.logger.new('app_launch_key.lua', 'debug')

--local application = require "hs.application"

local fn_app_key = {
    b = "Typora",
    D = 'Activity Monitor',
    v = "微信",
    k = "Karabiner-EventViewer",
    K = "Karabiner-Elements",
    w = 'YoudaoNote',
    W = 'Evernote',

    c = 'Charles',
    q = "QQ",
    g = "Postman",

    ['1'] = "Hammerspoon",
    ['2'] = 'Reminders',
    ['3'] = 'Calendar',
    ['4'] = "Be Focused",

    --['`'] = "屏幕共享",
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
    ['3'] = 'Google Chrome',
    ['#'] = 'Safari',
    ['4'] = 'PyCharm',
    ['$'] = 'DataGrip',
    ['r'] = '预览',
    --['g'] = 'google chrome canary',

    f = 'Notes',
    F = 'Stickies',
    c = 'HandShaker',
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
    [']'] = 'iTunes',
    ['}'] = 'VLC',
    [';'] = 'Photos',
    ['\''] = 'MPlayerX',
    [','] = '系统偏好设置',
    k = '迅雷'
}

hs.application.enableSpotlightForNameSearches(true);

-- 进入状态了后 再摁原键

local targetAppToggleIn = false  -- 上一个切换的程序 是 切进来了吗?
local focusedAppWinAmt = 0
local lastAppKey = ""
local hyperTrans = 0

---toggleApp
---切换应用
---@param UIName string 名字
---@return boolean, number  改目标应用的窗口 是不是切进来了, 活跃的窗口数量是多少
local function toggleApp(Name)
    local uiName = getUIName(Name) or Name
    local startName = getStartName(uiName) or uiName
    local runningApp = hs.appfinder.appFromName(uiName) or hs.application.get(uiName)
    log.f("uiName = %s", uiName)
    if not runningApp then
        log.f(' runningApp = %s, startName = %s, uiName = %s', hs.inspect(runningApp), startName, uiName)
        hs.application.launchOrFocus(startName) -- 虚拟机共享的软件
        return true, 1
    end

    local mainwin = runningApp:mainWindow()
    local wins = runningApp:allWindows()

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
        hs.application.open(startName)
        return true, #wins
    end
end

local isSingleFnOrAlt = function(flags)
    local cnt = 0
    local shiftOn = 0
    for _ in pairs(flags) do
        cnt = cnt + 1
    end

    if flags:contain({ "shift" }) then
        cnt = cnt - 1
        shiftOn = 1
    end

    if cnt == 1 and flags:contain({ "alt" }) or flags:contain({ "fn" }) then
        return shiftOn + 1
    else
        return false
    end
end

---松开opt 或者 fn的效果
---中断连续切换的状态 保持fn or opt hold on 就是保持状态, 切换其他 都是中断状态 除了shift
---@param evt table
local flagsChangedHander = function(evt)
    local flags = evt:getFlags()
    local ckey = evt:getKeyCode()

    if not isSingleFnOrAlt(flags) then
        return false
    end

    if ckey == hs.keycodes.map['shift'] then
        return
    end
    if hyperTrans == 0 then return end

    keyUpDown({}, 'escape')
    lastAppKey = {}
    targetAppToggleIn = false
    hyperTrans = 0

    return false
end

local message = require('keyboard.status-message')

local function t()
    local helpContent = 'fn app\n'
    local cnt = 0
    for key, appName in pairs(fn_app_key) do
        cnt = cnt + 1
        if cnt % 4 == 0 then
            helpContent  = helpContent  .. '\n'
        end
        helpContent = helpContent  .. string.format('%3s  %-21s', key, appName)
    end

    helpContent = helpContent .. '\n\nalt app\n'
    cnt = 0
    for key, appName in pairs(alt_app_key) do
        cnt = cnt + 1
        if cnt % 4 == 0 then
            helpContent  = helpContent  .. "\n"
        end
        helpContent = helpContent  .. string.format('%3s  %-21s', key, appName)
    end

    local statusMessage = message.new(helpContent)
    return statusMessage
end
local statusMessage = t()


local helpMsgCnt = 0
---fnOrAltCatcher 切换应用程序的捕捉  Fn alt  加上了shift. 后松shift
-- 摁下 单个的Fn/alt + 数字字母, 切换应用.
-- 集体出来并激活焦点, 集体隐藏, 循环应用窗口.... 松开flag 就停止到相应的状态.
-- 比如chrome有3个窗口, 处于未激活状态: 摁住alt, 摁下 5 次 3
--     先chrome窗口集体出来, 消失, 然后开始循环窗口... 过程中, 松开alt就停止到相应的状态   需要配合 HyperSwitch
--     有些符号自带 fn
---@param event function
local function fnOrAltCatcher(event)
    local flags = event:getFlags()

    if not isSingleFnOrAlt(flags) then
        return false
    end

    local ckey = event:getCharacters(true)
    local keyCode = event:getKeyCode()
    if FnKeyCodeInRange(keyCode) then
        return false
    end

    log.f('\n\t\t targetAppToggleIn = %s, focusedAppWinAmt = %s, lastAppKey = %s, hyperTrans = %d \n',
            targetAppToggleIn, focusedAppWinAmt, hs.inspect(lastAppKey), hyperTrans)

    local appName = flags:contain({ "fn" }) and fn_app_key[ckey] or flags:contain({ "alt" }) and alt_app_key[ckey]
    if not appName then
        if ckey == 'R' then
            hs.reload()
            return true, {}
        end
        if ckey == '`' then
            if helpMsgCnt % 2 == 0 then
                statusMessage:show()
            else
                statusMessage:hide()
            end
            helpMsgCnt = helpMsgCnt + 1

            return true, {}
        end
        flagsChangedHander(event)
        return false
    end
    log.f("appName = '%s'", appName)

    if targetAppToggleIn and focusedAppWinAmt > 1 then
        if lastAppKey == ckey then
            if hyperTrans < focusedAppWinAmt then
                hyperTrans = hyperTrans + 1
                return true, { hs.eventtap.event.newKeyEvent({ "alt" }, '`', true) } -- cmd + ` ok too
            else
                flagsChangedHander(event)
            end
        elseif lastAppKey ~= ckey then
            flagsChangedHander(event)
            lastAppKey = ckey
        end
    end

    targetAppToggleIn, focusedAppWinAmt = toggleApp(appName)
    lastAppKey = ckey
    return true, {}
end

local fnAltAppTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, fnOrAltCatcher)
fnAltAppTapper:start()

local flagTapper = hs.eventtap.new({ hs.eventtap.event.types.flagsChanged }, flagsChangedHander)
flagTapper:start()



return { endfnAltAppTapper = fnAltAppTapper, modifierDownHander = modifierDownHander }
