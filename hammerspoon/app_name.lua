local file_app = {
    '备忘录', 'Notes',
    '便笺', 'Stickies',
    '词典', 'Dictionary',
    '地图', 'Maps',
    '国际象棋', 'Chess',
    '计算器', 'Calculator',
    '日历', 'Calendar',
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
    '微信', 'WeChat',
    'Airmail 3', 'Airmail',
    '迅雷', 'Thunder',
    'iTerm', 'iTerm2',
    '屏幕共享', 'Screen Sharing',
    'AliWangwang', '阿里旺旺',
    --'Postman', "/Users/xujiazhe/Applications/Chrome Apps.localized/Default fhbjgbiflinjbdggehcddcbncdddomop.app",
    '/Applications/iTunes.app/Contents/MacOS/iTunes', 'iTunes'
}

---translateName
---文件名和应用名 切换
---
--- '备忘录' = translateName('Notes')
---
---@param name string
---@return string

local function switchName(name)
    local map = { [1] = 1, [0] = -1 }
    for index, sname in ipairs(file_app) do
        if sname == name then
            return file_app[index + map[index % 2]]
        end
    end
    return nil
end

return switchName
