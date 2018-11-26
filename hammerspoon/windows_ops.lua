hs.window.animationDuration = 0

-- todo winLno[cWinId] = gi(1).currentline   table.update return true  更新语法

function hs.window.moveScreen(win, step)
    local currentScreen = win:screen()
    local allScreens = hs.screen.allScreens()
    local screenLen = #hs.screen.allScreens()
    local currentScreenIndex = hs.fnutils.indexOf(allScreens, currentScreen)
    local nextScreenIndex = (currentScreenIndex + screenLen + step - 1) % screenLen + 1

    if allScreens[nextScreenIndex] then
        win:moveToScreen(allScreens[nextScreenIndex])
    else
        win:moveToScreen(allScreens[1])
    end

    return true
end

local gi = debug.getinfo
local cWinId = 0
local winLno = { } -- 跳屏功能, 但有些窗口最小宽度大于半屏, 为了能sf跳屏, 有一个win重复状态的判断
local dl = { __index = function()
    return 0
end }
setmetatable(winLno, dl)

---WinOpsCatcher
--- fn + sdef 操作当前窗口
---     上下左右 步幅易懂
---     跳屏
---@param event table
---@return boolean
local function WinOpsCatcher(event)
    local flags = event:getFlags()
    if not flags:containExactly({ "fn" }) then
        return false
    end
    local ckey = event:getCharacters(true)
    startNo, en = string.find("sdefaz", ckey)
    print(ckey)
    if not startNo then
        return false
    end
    local win = hs.window.focusedWindow()
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()
    cWinId = win:id()

    if ckey == 'e' then
        -- 上 上有空 补上; 上没空 空下;
        if winFrame.y > screenFrame.y then
            winLno[cWinId] = gi(1).currentline
            winFrame.h = (winFrame.y - screenFrame.y) + winFrame.h;
            winFrame.y = screenFrame.y;
        else
            winLno[cWinId] = gi(1).currentline
            winFrame.h = screenFrame.h / 2;
            winFrame.y = screenFrame.y;
        end
        win:setFrame(winFrame);
    elseif ckey == 'd' then
        -- 下 下有空 补下;  下没空 空上;
        if ((winFrame.y + winFrame.h + 5.1) < (screenFrame.y + screenFrame.h)) then
            winLno[cWinId] = gi(1).currentline
            winFrame.h = winFrame.h + screenFrame.y + screenFrame.h - winFrame.y - winFrame.h;
        else
            winLno[cWinId] = gi(1).currentline
            winFrame.y = screenFrame.h / 2 + screenFrame.y;
            winFrame.h = screenFrame.h / 2;
        end
        win:setFrame(winFrame);
    elseif ckey == 's' then
        if winFrame.x > screenFrame.x then
            winLno[cWinId] = gi(1).currentline
            winFrame.w = winFrame.w + (winFrame.x - screenFrame.x);
            winFrame.x = screenFrame.x;
        elseif winFrame.w == (screenFrame.w / 2) then
            winLno[cWinId] = gi(1).currentline
            return win:moveScreen(-1), {}
        else
            local lno = gi(1).currentline
            if winLno[cWinId] == lno then
                return win:moveScreen(-1), {}
            else winLno[cWinId] = lno
            end
            winFrame.w = screenFrame.w / 2;
        end
        win:setFrame(winFrame);
    elseif ckey == 'f' then
        if (winFrame.x + winFrame.w) < (screenFrame.x + screenFrame.w) then
            local lno = gi(1).currentline
            if winLno[cWinId] == lno then
                return win:moveScreen(1), {}
            else winLno[cWinId] = lno
            end
            winFrame.w = winFrame.w + (screenFrame.x + screenFrame.w) - (winFrame.x + winFrame.w);
        elseif winFrame.x == screenFrame.x + (screenFrame.w / 2) then
            winLno[cWinId] = gi(1).currentline
            return win:moveScreen(1), {}
        else
            winLno[cWinId] = gi(1).currentline
            winFrame.x = screenFrame.x + (screenFrame.w / 2);
            winFrame.w = screenFrame.w / 2;
        end
        win:setFrame(winFrame);
    elseif ckey == 'a' then
        winFrame.x = 0
        winFrame.y = 23.1
        winFrame.w = 1440 * 2
        winFrame.h = 2560 - 23.1
        print(hs.inspect(winFrame))
        win:setFrame(winFrame);
        print("print over¡")
    elseif ckey == 'z' then
        winFrame.w = winFrame.w - 20
--        winFrame.x = -1680
--        winFrame.y = 23.1
--        winFrame.w = 1440 * 2 + 1680
--        winFrame.h = 1440 + 1050 - 23.1
        win:setFrame(winFrame);
        print(hs.inspect(winFrame))
    else
        print("couldn't be here Fn+", ckey);
    end

    return true, {}
end

local windowsOpsTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, WinOpsCatcher)
windowsOpsTapper:start()

return windowsOpsTapper;


--local function WinOpsHandler(event)
--    local status = pcall(WinOpsHandler, event)
--    print("status ", status)
--    print("err ", err)
--
--    if status == true then
--        return true, {}
--        -- print("WinOpsCatcher so far so good")
--    else
--        print("That method is broken, fix it!")
--        return false
--    end
--
--end
-- 新窗口激活 状态变化
-- 窗口大小调整状态
-- 切换状态
-- 快键程序表格

-- 在



