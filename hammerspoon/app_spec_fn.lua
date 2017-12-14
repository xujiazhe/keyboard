local log = hs.logger.new('app_spec_fn.lua', 'debug')
--local wins = require('windows')

local AppMenuDict = {
    ["Finder"] = { "显示", "显示边栏" },
    ["Reminders"] = { "显示", "显示边栏" },
    ["Notes"] = { "显示", "显示文件夹" },
    ["Calendar"] = { "显示", "显示日历列表" },
    ["Typora"] = { "显示", "文件树视图" },
    ["Safari"] = { "显示", "显示阅读列表边栏" }
}
local AppMenuDict2 = {
    ["Finder"] = { "显示", "隐藏边栏" },
    ["Reminders"] = { "显示", "隐藏边栏" },
    ["Notes"] = { "显示", "隐藏文件夹" },
    ["Calendar"] = { "显示", "隐藏日历列表" },
    ["Typora"] = { "View", "File Tree" },
    ["Safari"] = { "显示", "隐藏阅读列表边栏" }
}

local function cmdFunction(event)
    local ckey = event:getCharacters(true)
    if ckey ~= '1' then
        return false
    end

    local win = hs.window.focusedWindow()
    local app = win:application()
    local UIName = app:name()
    startName = getStartName(UIName) or UIName
    print("startName" , startName)

    -- hs.application.launchOrFocus("Safari")
    -- local safari = hs.appfinder.appFromName("Safari")
    -- local str_default = {"开发", "用户代理", "Default (Automatically Chosen)"}
    local menu1 = AppMenuDict[startName]
    local menu2 = AppMenuDict2[startName]

    local exist_menu = menu1 and app:findMenuItem(menu1) and menu1
    if not exist_menu then
        exist_menu = menu2 and app:findMenuItem(menu2) and menu2
    end

    if exist_menu then
        app:selectMenuItem(exist_menu)
        return true, {}
    end
    -- print(default, ie10, chrome)
    -- print(ie10["ticked"])
    -- if (default and default["ticked"]) then
    --     print("one")
    --     safari:selectMenuItem(str_ie10)
    --     hs.alert.show("IE10")
    -- end
    return false
end

local isInTerminal = function()
    app = hs.application.frontmostApplication():name()
    return app == 'iTerm2' or app == 'Terminal' or app == '终端'
end

local itermHotkeyMappings = {
    -- Use control + dash to split panes horizontally
    {
        from = { { 'ctrl' }, '-' },
        to = { { 'cmd', 'shift' }, 'd' }
    },

    -- Use control + pipe to split panes vertically
    {
        from = { { 'ctrl' }, '\\' },
        to = { { 'cmd' }, 'd' }
    }
}

local function ctrlFunction(event)
    local flags = event:getFlags()
    local ckey = event:getCharacters(true)
    local appName = hs.application.frontmostApplication():name()

    if appName == 'iTerm2' then
        for i, mapping in pairs(itermHotkeyMappings) do
            local fromMods = mapping['from'][1]
            local fromKey = mapping['from'][2]
            local toMods = mapping['to'][1]
            local toKey = mapping['to'][2]

            if flags:containExactly(fromMods) and ckey == fromKey then
                keyUpDown(toMods, toKey)
                return true, {} -- { hs.eventtap.event.newKeyEvent(toMods, toKey, true) }
            end
        end
    else
        -- if not isInTerminal() and ckey == 'u' then
        --     keyUpDown({ 'cmd', 'shift' }, 'left')
        --     keyUpDown({}, 'forwarddelete')
        --     return true, {}
        -- end
    end
    return false
end

local function appSpecialFunction(event)
    local ckey = event:getCharacters(true)
    local UIName = hs.application.frontmostApplication():name()
    if UIName == '备忘录' and ckey == '\t' then
        hs.eventtap.keyStrokes("    ")
        return true, {}
    end
    return false
end

-- 位置 terminal 新增的编辑功能.位置


local function modifiersCatcher(event)
    local flags = event:getFlags()
    local ckey = event:getCharacters(true)
    local keycode = event:getKeyCode()

    -- 在屏幕共享 窗口下, 不能调出里面的屏幕共享程序  防止出现屏幕循环
    if flags:containExactly({ 'fn' }) and ckey == '`' then
        return true, {}
    end

    if flags:containExactly({ 'cmd' }) then
        return cmdFunction(event)
    elseif flags:containExactly({ 'ctrl' }) then
        return ctrlFunction(event)
    --elseif ckey == '\t' then
    --    return appSpecialFunction(event)
    end

    return false
end

local appFunctionTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, modifiersCatcher)
appFunctionTapper:start()
