hs.window.animationDuration = 0


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
end


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
    startNo, en = string.find("sdef", ckey)
    if not startNo then
        return false
    end

    local win = hs.window.focusedWindow()
    local winFrame = win:frame()
    local screenFrame = win:screen():frame()

    if ckey == 'e' then
        -- 上 上有空 补上; 上没空 空下;
        if winFrame.y > screenFrame.y then
            winFrame.h = (winFrame.y - screenFrame.y) + winFrame.h;
            winFrame.y = screenFrame.y;
        else
            winFrame.h = screenFrame.h / 2;
            winFrame.y = screenFrame.y;
        end
        win:setFrame(winFrame);
    elseif ckey == 'd' then
        -- 下 下有空 补下;  下没空 空上;
        if ((winFrame.y + winFrame.h + 5.1) < (screenFrame.y + screenFrame.h)) then
            winFrame.h = winFrame.h + screenFrame.y + screenFrame.h - winFrame.y - winFrame.h;
        else
            winFrame.y = screenFrame.h / 2 + screenFrame.y;
            winFrame.h = screenFrame.h / 2;
        end
        win:setFrame(winFrame);
    elseif ckey == 's' then
        if winFrame.x > screenFrame.x then
            winFrame.w = winFrame.w + (winFrame.x - screenFrame.x);
            winFrame.x = screenFrame.x;
        elseif winFrame.w == (screenFrame.w / 2) then
            win:moveScreen(-1)
            return true, {}
        else
            winFrame.w = screenFrame.w / 2;
        end
        win:setFrame(winFrame);
    elseif ckey == 'f' then
        if (winFrame.x + winFrame.w) < (screenFrame.x + screenFrame.w) then
            winFrame.w = winFrame.w + (screenFrame.x + screenFrame.w) - (winFrame.x + winFrame.w);
        elseif winFrame.x == screenFrame.x + (screenFrame.w / 2) then
            win:moveScreen(1)
            return true, {}
        else
            winFrame.x = screenFrame.x + (screenFrame.w / 2);
            winFrame.w = screenFrame.w / 2;
        end
        win:setFrame(winFrame);
    else
        print("couldn't be here Fn+", ckey);
    end
    return true, {}
end

local windowsOpsTapper = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, WinOpsCatcher)
windowsOpsTapper:start()

return windowsOpsTapper;
