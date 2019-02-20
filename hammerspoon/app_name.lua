local UI_Terminal_Names = {
    '备忘录', 'Notes',
    '便笺', 'Stickies',
    '词典', 'Dictionary',
    '地图', 'Maps',
    '国际象棋', 'Chess',
    '计算器', 'Calculator',
    '日历', 'Calendar',
    '有道云笔记', 'YoudaoNote',
    '提醒事项', 'Reminders',
    '通讯录', 'Contacts',
    '图像捕捉', 'Image Capture',
    '文本编辑', 'TextEdit',
    '系统偏好设置', 'System Preferences',
    '信息', 'Messages',
    '邮件', 'Mail',
    '预览', 'Preview',
    '照片', 'Photos',
    '字体册', 'Font Book',
    'Airmail 3', 'Airmail',
    '迅雷', 'Thunder',
    'FaceTime 通话', 'FaceTime',
    '图书', 'Books',
    'Safari 浏览器', 'Safari',
    'iTerm2', 'iTerm',
    '屏幕共享', 'Screen Sharing',
    '阿里旺旺', 'AliWangwang',
    '活动监视器','Activity Monitor',
    '脚本编辑器', 'Script Editor',
    --'Postman', "/Users/xujiazhe/Applications/Chrome Apps.localized/Default fhbjgbiflinjbdggehcddcbncdddomop.app",
    "Hammerspoon", "/Applications/Hammerspoon.app",
    'iTunes', '/Applications/iTunes.app/Contents/MacOS/iTunes'
}

-- Finder中文件名字(系统中右上角应用的名字)
-----界面显示和常用, 找活动窗口用

-- 启动的名字/终端名字
-----实际的启动名字

---translateName
---文件名和应用名 切换
---
--- '备忘录' = translateName('Notes')
---
---@param name string
---@return string

function getUIName(name)
    local map = { [1] = 1, [0] = -1 }
    for index, sname in ipairs(UI_Terminal_Names) do
        if sname == name then
            if index % 2 == 0 then
                return UI_Terminal_Names[index + map[index % 2]]
            else
                return nil
            end
        end
    end
    return nil
end

function getStartName(name)
    local map = { [1] = 1, [0] = -1 }
    for index, sname in ipairs(UI_Terminal_Names) do
        if sname == name then
            if index % 2 == 1 then
                return UI_Terminal_Names[index + map[index % 2]]
            else
                return nil
            end
        end
    end
    return nil
end

