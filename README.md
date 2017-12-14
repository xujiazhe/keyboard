## 脚本整理融合

感谢 [jasonrudolph](https://github.com/jasonrudolph/keyboard) 分享出来的hammperspoon脚本.
代码在[github](https://github.com/xujiazhe/keyboard/tree/xujiazhe)上
mac的应用窗口和应用切换功能太弱.
	在win下
		win+数. 切换任务栏上的窗口 !
		win+方向键调整当前窗口 !

## 功能列表

- [切换应用](#切换应用)   Fn/opt + 数字/字母 -> 切换/启动 应用
- [窗口调整](#窗口调整)   Fn + sdfe 调整
- [karabiner配置](#karabiner配置)  键位映射和space模式
- [一些APP下的功能](#一些APP下的功能) 在一些app下的特别功能


### 切换应用

Fn/Alt  +  数字/符号/大小写字母 切换应用

在 hammerspoon/app_launch_key.lua 文件中, 这两个配置表, 是 键<-->应用 关联表

<u>摁住opt, 敲下2后, 就是idea, 在敲下2, 如果idea的窗口有多个, 就切换idea的窗口, 这个功能需要HyperSwitch配合, 设置alt+`是应用窗口切换</u>

*hammerspoon/app_name.lua 应用的  名字  和 文件名切换*

```lua
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
    ['t'] = "Sequel Pro"
}

local alt_app_key = {
    ['1'] = 'iTerm',
    ['!'] = "Terminal",
    ['2'] = 'IntelliJ IDEA',
    ['@'] = "Atom",
    ['3'] = 'Safari',
    ['#'] = 'Google Chrome',
    ['4'] = 'PyCharm',
    ['5'] = 'DataGrip',

    f = 'Notes',
    e = 'Finder',
    E = 'Microsoft Excel',
    v = '微信',

    [';'] = 'Photos',
    ['\''] = 'MPlayerX',
    [','] = '系统偏好设置'
}
```
Fn键功能图![Fn键功能图](screenshots/keyboard-layout-alt.png)
Alt键功能图![Alt键功能图](screenshots/keyboard-layout-fn.png)
### 窗口调整

1. Fn + sdfe 灵活调整窗口 类似 win + 方向键
  - sdfe 就当方向键, 摁e, 窗口就往上走, 恩 是走到上面去 !


### karabiner配置

*针对不同的键盘设备可有不同的配置.*

- caps_lock     ->   right_control
- left_control   ->    删除 / Fn


1. 按住space, 进入spacebar模式, 该模式下的  键位映射有

  - <kbd>esdf</kbd> ->方向键
  - <kbd>wrxv</kbd> -> home, end, pageup, pagedown
  - <kbd>\`</kbd>, <kbd>1-9,0,-,=</kbd>-> ESC,   F1 ~ F12
  - <kbd>b</kbd> -> 空格,   <kbd>z</kbd> -> ESC

2. 快键 就是单独短时按下

  - left_cmd   ->    方向键下
  - left_opt     ->    方向键上
  - left_ctrl     ->    enter
  - 双shift       ->    caps_lock

#### 图示
初始布局![image](screenshots/keyboard-layout0.png)
按住spacebar进入spacebar模式 ![image](screenshots/keyboard-layout1.0.png)
按一下w切换到鼠标模式 ![image](screenshots/keyboard-layout1.1.1.png)
按住a进入滚轮模式 ![image](screenshots/keyboard-layout1.1.2.png)
spacebar模式和fn结合的功能图 ![image](screenshots/keyboard-layout1.2.1.png)
spacebar模式和alt结合的功能图 ![image](screenshots/keyboard-layout1.2.2.png)
系统中的键设置 ![image](screenshots/keyboard-layout1.2.3.1.png)
spacebar模式和ctrl结合的功能图 ![image](screenshots/keyboard-layout1.2.3.png)
###### TODO 一般键盘有按键冲突 比如  Spacebar+Fn+ -号 不能减小声音

### 一些APP下的功能


1. 我用台式机工作, 笔记本开会, 两台机器之间有时候远程桌面操作,  微信/钉钉 在笔记本上常开.
   在台式机上摁下  Fn/opt + v的时候, 是打开 远程窗口(台式机) 上的 微信/钉钉

2. 在Finder, Reminder, 备忘录中 cmd + 1 是toggle边栏.
3. 在终端 alt + h/l 前/后删词, iterm2


📣 Shout-out to [Karabiner's Simultaneous vi Mode](https://github.com/tekezo/Karabiner/blob/05ca98733f3e3501e0679814c3795d1cb57e177f/src/core/server/Resources/include/checkbox/simultaneouskeypresses_vi_mode.xml#L4-L10) for providing the inspiration for (S)uper (D)uper Mode. ⌨:neckbeard:✨





## 依赖环境

- macOS Sierra, 10.12
- [Karabiner-Elements 0.91.7][karabiner]
- [Hammerspoon 0.9.52][hammerspoon]
- [HyperSwitch][hyperswitch]



## 安装使用

1. 下载代码

   ```sh
   git clone https://github.com/jasonrudolph/keyboard.git ~/.keyboard

   cd ~/.keyboard

   script/setup
   ```

2. 如果有自己hammerspoon脚本 或 karabiner.json, 自己做好整合哈. 使用后果自负.

3. Enable accessibility to allow Hammerspoon to do its thing [[screenshot]](screenshots/accessibility-permissions-for-hammerspoon.png)

4. 这个脚本有点bug, 能撑一个小时, 失灵了就 Fn/opt + shift + r, 重载一下 ^^.

## 开发

1. lua项目入口脚本 init.lua 导入相应的功能模块
2. Fn + 4 可打开 hammerspoon 的 console, 可以查看日志, 输入语句




## TODO
##### TODO 跳屏循环顺序不太对
##### TODO 菜单键(激活菜单后, 1234分别对应第几个选项)
- Add [#13](https://github.com/jasonrudolph/keyboard/pull/13) to [features](#features):
    - Hold option for push-to-talk/push-to-mute
    - Double-tap option to mute/unmute microphone

[customize]: http://dictionary.reference.com/browse/customize
[don't-make-me-think]: http://en.wikipedia.org/wiki/Don&amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;amp;#39;t_Make_Me_Think
[karabiner]: https://github.com/tekezo/Karabiner-Elements
[hammerspoon]: http://www.hammerspoon.org
[hammerspoon-releases]: https://github.com/Hammerspoon/hammerspoon/releases
[hyperswitch]: https://bahoom.com/hyperswitch
[modern-space-cadet]: http://stevelosh.com/blog/2012/10/a-modern-space-cadet
[modern-space-cadet-key-repeat]: http://stevelosh.com/blog/2012/10/a-modern-space-cadet/#controlescape
