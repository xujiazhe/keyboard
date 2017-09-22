local module = {}
module.debugging = true -- whether to print status updates

local windows_index = {
    {},
    {},
    {}
}
local mt = {__index = function () return 1 end}
setmetatable(windows_index[1], mt)
setmetatable(windows_index[2], mt)
setmetatable(windows_index[3], {__index = function () return -2 end})

module.windows_ops = function (key)
    local wid = 0
    if not module.debugging then
        local fwin = hs.window.focusedWindow()
        if not fwin then return key end
        wid = fwin:id()
    end
    local vindex = windows_index[1][wid]
    local hindex = windows_index[2][wid]
    local dstrs = {
        'dceg',
        'dfwf',
        'dfrf'
    }

    local direction = 0
    local char = 'd'
    if key == 'e' or key == 'd' then
        direction = 1
        local dict = {e = 1, d = (#dstrs[direction] - 1)}
        vindex = (vindex + dict[key] -1) % #dstrs[direction] + 1
        char = string.sub(dstrs[direction], vindex, vindex)
        windows_index[direction][wid] = vindex
    elseif key == 's'  then
        direction = 2
        hindex = (hindex + 1 -1) % #dstrs[direction] + 1
        char = string.sub(dstrs[direction], hindex, hindex)
        windows_index[direction][wid] = hindex
    elseif key == 'f' then
        direction = 3
        hindex = (hindex + #dstrs[direction] - 1 -1) % #dstrs[direction] + 1
        char = string.sub(dstrs[direction], hindex, hindex)
        windows_index[2][wid] = hindex
    else
        return key
    end
    --  先判断方
    --  拿到以前的状态
    --  循环key状态

    -- 中下上全 中   逆序       dceg
    -- 中左(跨左/右全屏)右 中左   dfr/wf
    -- VH状态变换, 另一个清零
    local last_direction = windows_index[3][wid] -- -2
    if last_direction ~= -2 and math.floor(last_direction/2) ~= math.floor(direction/2) then
        windows_index[math.floor(last_direction/2)+1][wid] = 1
        print("change last direction = " .. last_direction, direction)
    end
    windows_index[3][wid] = direction

    return char
end


if module.debugging then
    hs.hotkey.bind({"ctrl", "cmd", "shift", "alt"}, 'x', function(event)
        res = ''
        print ("start test")
        for i = 0, 10 do
            local char = module.windows_ops('e')
            print(char)
            res = res .. char
        end
        print (res, "\nend test")

        print ("start test")
        res = ''
        local test_a = "sssssssssffffffffeeeedddddd"
        for i = 1, #test_a do
            local c = test_a:sub(i,i)
            local char = module.windows_ops(c)
            print(char)
            res = res .. char
        end
        print (test_a)
        print (res, "\nend test")
    end)
end
