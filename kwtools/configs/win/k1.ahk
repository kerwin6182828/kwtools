; “；”在ahk中是备注的意思


; 需要让LCtrl+Tab实现“切换程序”的功能
LCtrl & Tab::AltTab
; 需要让LCtrl+F4实现“关闭程序”的功能
LCtrl & q::Send {LAlt} {F4}

; Caps已经被我从注册表中映射成了RAlt， 所以这个时候需要把RAlt打造成一个“万能键”！！
RAlt & j::Send {Down}
RAlt & k::Send {Up}
RAlt & h::Send {Left}
RAlt & l::Send {Right}
RAlt & n::Send {Backspace}
RAlt & m::Send {Delete}
RAlt & i::Send {PgUp}
RAlt & o::Send {PgDn}
RAlt & u::Send {Home}
RAlt & p::Send {End}
RAlt & NumpadAdd::Run www.baidu.com
RAlt & NumpadSub::Send {End}
RAlt & Enter::Send {ESC}



;超便捷打开chrome的百度页面！！
LWin & b::Run www.baidu.com






; 以下为学习测试内容
; =====================================================
; =====================================================
; =====================================================


;!b::Run www.baidu.com
;#n::Run Notepad

; ；是注释符号（可以把AHK理解成一种小众语言）
; 1. 把 Capslock 映射成 Control 键.
;Capslock::Ctrl
; 当您按住 shift 键并按下 Capslock 后就可以切换 Capslock 的状态
;+Capslock::Capslock

; 2. 把左 Control 键映射成 左Alt 键
;LCtrl::LAlt

; 3. 把左 Alt键映射成 左Ctrl键
;LAlt::LCtrl


;F1:: ;窗口切换 ALT+TAB
;send,!{tab}
;return



;alt+tab ---> control+tab （跳转到其他程序）



;RAlt & Tab::AltTab



;Space & Tab::AltTab  ; 不能使用， 否则会放空格失灵，失去他原本的功能

; LControl & c::run www.baidu.com
; *Tab::Send {Blind}{Tab}

; RControl & RShift::AltTab




