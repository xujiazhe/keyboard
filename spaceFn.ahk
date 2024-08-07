; 显示中文必须使用UTF-8-BOM编码本文件
;thttps://ahkcn.github.io/docs/misc/Clipboard.htm
#Persistent
#InstallKeybdHook
#SingleInstance force
SetTitleMatchMode 2
SendMode Input
Menu, Tray, Icon , Shell32.dll, 25, 1
TrayTip, AutoHotKey, Started, 1
SoundBeep , 300, 150 
RCtrl & Tab::
	Tooltip, reload %A_ScriptFullPath%
	sleep, 321
	Tooltip
	Reload
pycharm := "C:\Program Files\JetBrains\PyCharm 2024.1.4\bin\pycharm64.exe"
webstorm := "C:\Program Files\JetBrains\WebStorm 2024.1.5\bin\webstorm64.exe"


Activate(t)
{
  IfWinActive,%t%
  {
    WinMinimize
    return
  }
  SetTitleMatchMode 2    
  DetectHiddenWindows,on
  IfWinExist,%t%
  {
    WinShow
    WinActivate           
    return 1
  }
  return 0
}

ActivateAndOpen(t,p)
{
  if Activate(t)==0
  {
    Run %p%
    WinActivate
    return
  }
}

RCtrl & 1::
	ActivateAndOpen("WPS Office","C:\Users\xujiazhe\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\WPS Office")
	return
RCtrl & 2:: 
	ActivateAndOpen("Sourcetree","C:\Users\xujiazhe\AppData\Local\SourceTree\SourceTree.exe")
	return
RCtrl & 3::
	;WinShow, "ahk_exe Ueli.exe"  ^Y不行
	
	KeyWait, 3
    If (A_TimeSinceThisHotkey < 300) {
		ActivateAndOpen("ahk_exe pycharm64.exe", pycharm)
	}
	else
	{
		ActivateAndOpen("ahk_exe webstorm64.exe", webstorm)
	}
	;ActivateAndOpen("WebStorm", "C:\Program Files\JetBrains\WebStorm 2024.1.5\bin\webstorm64.exe")
	return
;https://superuser.com/questions/1265330/autohotkey-to-cycle-through-active-program-windows
RCtrl & 4::
	IfWinNotExist, ahk_class CabinetWClass
		Run, explorer.exe
	GroupAdd, kjexplorers, ahk_class CabinetWClass ;You have to make a new group for each application, don't use the same one for all of them!
	if WinActive("ahk_exe explorer.exe")
		GroupActivate, kjexplorers, r
	else
		WinActivate ahk_class CabinetWClass ;you have to use WinActivatebottom if you didn't create a window group.
	Return


RAlt & 1::
	IfWinNotExist ahk_class CalcFrame
	{
	  Run calc.exe
	  WinActivate
	}
	Else IfWinNotActive ahk_class CalcFrame
	{
	  WinActivate
	}
	Else
	{
	  WinMinimize
	}
	Return
; reload script https://stackoverflow.com/questions/15706534/hotkey-to-restart-autohotkey-script


~RCtrl up::
	;ToolTip, %A_PriorKey%
	If (A_PriorKey = "RControl" ) {
		Send {Enter}
	}
	return

RCtrl & r:: 
	if WinActive("ahk_exe wps.exe") { 
		Send, ^{Tab}
	}
	else
		Send, ^{PgDn}
	return
RCtrl & w:: 
	if WinActive("ahk_exe wps.exe") {
		Send, ^+{Tab}
	}
	else
		Send, ^{PgUp}
	return
RCtrl & q:: Send, !{Esc}
RCtrl & e:: Send, !+{Esc}

;先把space基础功能调好
; reload script https://stackoverflow.com/questions/15706534/hotkey-to-restart-autohotkey-script

;space as modifier key
;抄袭 https://www.reddit.com/r/AutoHotkey/comments/oq23r4/is_there_a_way_to_use_space_as_a_modifier/
;好东西  https://github.com/almogtavor/static-hands

Space::·
	If SpacePressed ; AutoRepeat defense
		Return
	SpacePressed:=true
	SpaceTimeout := false
	SetTimer ModActivate, % SpaceTimeoutLimit
	Return

Space Up::
	SpacePressed:=false
	SetTimer ModActivate, Off
	If ((A_PriorKey = "Space") AND !SpaceTimeout){
		Send {Blind}{Space}
	}
	Return
ModActivate:
	SpaceTimeout := true
	Return

Space & e::Up
Space & s::Left
Space & d::Down
Space & f::Right

Space & w::PgUp
Space & r::PgDn
Space & a::Home
Space & g::End

Space & j::BackSpace
Space & c::AltTabMenu
Space & z::ESC

;Space & RCtrl::Enter
Space & Tab::
	KeyWait, Tab
    If (A_TimeSinceThisHotkey < 300) {
		Send, {BackSpace}
	}
	else {
		Send, {Delete}
	}
	return
Space & h::Delete
;CapLock & Space::Enter


;https://ahkcn.github.io/docs/misc/Clipboard.htm
~LCtrl up::
	If (A_PriorKey = "LControl") {
		Send {Esc}
	}
	return

#F::
    KeyWait, F
    If (A_TimeSinceThisHotkey < 300) {
        ; 按下小于300ms，打开Downloads文件夹
        Run "C:\Users\xujiazhe\Desktop\CL3" , Max
    } Else {
        ; 按下超过300ms，打开docs文件夹
        Run "D:\"
    }
Return


#If PName := BrowserActive()
    F4::SoundBeep, PName = "ApplicationFrameHost.exe" ? 523 : 300
#If
BrowserActive()
{
	WinGet, pName, ProcessName, A
	;Msgbox % pName
	if pName in msedge.exe,chrome.exe,firefox.exe,iexplore,ApplicationFrameHost.exe,notepad++.exe
		return pName
	return 0
}

RCtrl & 6::
	Gui,Add,ListBox,vWinList w200 r10,Wait..
	Gui,Show
	GoTo WinList

	WinList:
	WinGet,WinList,List,,,Program Manager
	List=
	loop,%WinList%{
		Current:=WinList%A_Index%
		WinGetTitle,WinTitle,ahk_id %Current%
		If WinTitle AND !InStr(List,WinTitle)
		List.="`n" "--- " WinTitle
	}
	GuiControl,+HScroll,WinList
	Gui +Delimiter`n
	GuiControl,,WinList,%List%
	Return

	GuiClose:
	return
	;ExitApp


RCtrl & 5:: 
	;TrayTip,,"helo word"
	WinGet windows, List
	r :=
	Loop %windows%
	{
		id := windows%A_Index%
		WinGetTitle wt, ahk_id %id%
		if wt {
		r .= wt . "`n" 
		}
	}
	MsgBox %r%
	return


RCtrl & f::
	;if WinActive("ahk_class Notepad")
	if  WinExist("ahk_exe wps.exe") {
		;Tooltip, ^f-test wps
		Send, ^{Tab}
	}
	else
	{
		;Tooltip,  ^f-not wps
		;TODO 要么是AHK有bug，要么就邪门了
	}
	;FileAppend, 测试wps, w测试%A_Now%.txt,UTF-8-RAW
	
	return
RCtrl & 7::Tooltip 你好世界! , A_ScreenWidth, A_ScreenHeight
RCtrl & z::
	MsgBox, %A_PriorKey% | %A_PriorHotKey%
	MsgBox, %A_PriorKey% | %A_PriorHotKey%
	return
RCtrl & z up::
	Tooltip, 2 %A_PriorKey% | %A_PriorHotKey%
	return   ; hotkey可以重复

	
RCtrl & F2::
	;Tooltip 写入%Clipboard%! , A_ScreenWidth, A_ScreenHeight 
	;FileAppend, Text, *
	FileAppend, %Clipboard%, g写入%A_Now%.txt,UTF-8-RAW
	Tooltip,%ErrorLevel%
	return
;TODO 向特别进程发送事件

;TODO 说起来语言成分鉴定
voice := ComObjCreate("SAPI.SpVoice")	; or use TTS_CreateVoice()
RCtrl & x::
	; SpVoice = ???   Seems like it would just be a short piece here directing to specified voice...
	;voice.Speak("说中文才是关键啊.")	; or use TTS()
	voice.Speak(clipboard)
	;voice := ""
	Return
#z::
    names := ""
    ;voice := ComObjCreate("SAPI.SpVoice")

    Loop, % voice.GetVoices.Count
    {
        names .= voice.GetVoices.Item(A_Index-1).GetAttribute("Name") . "`n"    ; 0 based
    }
	
    ;msgbox % names
	Try {
	  voice.Voice := voice.GetVoices.item(1)
	  ;for SpObjectToken in ComObjCreate("SAPI.SpVoice").GetVoices()
		MsgBox % names
	}
	;TODO clipboard = */
    Send,{CTRL Down}c{CTRL Up}
    Sleep, 100  
	
	voice.Speak(clipboard)
    ;voice.Voice := voice.GetVoices("Name=Microsoft Zira Desktop").Item(0) ; set voice to param1
    return




SendMode Input  ; 
SetWorkingDir %A_ScriptDir%  ;
SetTitleMatchMode 2
;RCtrl & v:: !#^+v
;TODO M595只有滚轮右侧出出发下一行 而
;WheelRight::return ToolTip, WheelRight 可用
;WheelLeft::	ToolTip, WheelLeft 可用
/*#Include C:\Users\xujiazhe\Desktop\Translation-Terminator\Lib\BaiduTranslator.ahk
BaiduTranslator.init()                        ; 初始化接口
WheelRight::
	; Translate text from Japanese to English.	\
	Tooltip,  开始 百度 翻译 
	;MsgBox, % BaiduTranslator.translate("今日の天気はとても良いです", "ja", "en")
	
	CL3Api_State("off")
	Send, ^c
	Sleep 100
	
	MsgBox, % BaiduTranslator.translate(Clipboard)
	CL3Api_State("on")
	
	;BaiduTranslator.free()
	;ExitApp
	return
*/
MButton::
	CL3Api_State("off")
	Send, {MButton}
	Sleep 100
	CL3Api_State("on")
	return
RCtrl & g::
	CL3Api_State("off")
	Send, ^c
	Sleep, 400
	Send, ^+!#g
	CL3Api_State("on")
	return

EncodeDecodeURI(str, encode := true, component := true) {
   static Doc, JS
   if !Doc {
      Doc := ComObjCreate("htmlfile")
      Doc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
      JS := Doc.parentWindow
      ( Doc.documentMode < 9 && JS.execScript() )
   }
   Return JS[ (encode ? "en" : "de") . "codeURI" . (component ? "Component" : "") ](str)
}

>^t::
	;TODO yt?关键词
	CL3Api_State("off")
	Send, ^c
	Sleep 100
	q_str := EncodeDecodeURI(clipboard)
	run "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" https://www.google.com/search?q=%q_str% , Max
	;TODO 两次点击
	CL3Api_State("on")
	return

;CapsLock & t:: Run Powershell
;汇总
;https://github.com/ahkscript/awesome-AutoHotkey
;https://www.downza.cn/soft/317706.html
;交换alt和ctrl   	Ubuntu下 https://blog.csdn.net/ruoshuixx/article/details/130267984

;<^#t:

RCtrl & `:: 
	Reload
	return
;Run "C:\Program Files\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1"

;Space::  return
/*Space Up:: 
	if (A_PriorKey = "Space" AND A_TimeSincePriorHotkey < 125)
    {
        Send {Space}
    }
    return
*/
RCtrl & h::
	ToolTip, %ClipboardHistoryToggle%
	 CL3Api_State(ClipboardHistoryToggle)
;	 Menu, Tray, ToggleCheck, &Pause clipboard history
	 If ClipboardHistoryToggle
		Menu, Tray, Icon, res\cl3.ico
	 else
		Menu, Tray, Icon, res\cl3_clipboard_history_paused.ico
	 ClipboardHistoryToggle:=!ClipboardHistoryToggle
	 return
