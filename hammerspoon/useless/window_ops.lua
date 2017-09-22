local HyperKey = { "ctrl", "alt", "cmd", "shift" };
local win_ops_keys = "wersdfcg"
elseif string.match(win_ops_keys, key) then
-- 窗口操作
-- key = wins.windows_ops(key)
print('char = ' .. key, string.match(win_ops_keys, key) )
return true, { hs.eventtap.event.newKeyEvent(HyperKey, key, true) } --{ hs.eventtap.keyStroke(HyperKey, key) }
