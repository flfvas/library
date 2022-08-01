*$Up::
 Goto, vol+
 return
*$Down:: ;还可以这样:>^left::SoundSet -5
 Goto, vol-
 return
 ^NumpadMult::Send {Volume_mute}
 
vol+:
 vol-:
 
GUI_W=700 ;设置gui的宽度;
GUI_H=80 ;设置gui的高度(包括上下文字在内了)
Gui_X :=(A_ScreenWidth-GUI_W)/2 ;"" 取屏幕中间一半的地方放置gui
 Gui_Y := A_ScreenHeight-190 ;s
 wp:=GUI_W*0.9 ;w-H ;进度条的长度
hp:=GUI_H/3 ;进度条高度
xp:=(GUI_W-wp)/2 ;进度条x位置
Back_Colour := 0x000000 ;背景色:黑色
Font_Colour := 0xFFFFFF ;字体颜色:白色;
BackBar_Colour := 0x000000 ;进度条背景色：黑色
Bar_Colour := 0x0000FF ;活动进度条颜色：蓝色
Max_Trans := 200 ;最大透明度
SoundGet, Vol ;获取主音量；
Curr_Vol := Vol ;将当前主音量赋予当前的音量；
Trans := Max_Trans ;透明度赋值
IfWinnotExist,Vol_OSD ;若不存在则创建窗口;
 {
GUI, Color, % Back_Colour, ;设置gui背景颜色为黑色;
GUI, Font, c%Font_Colour% s13 ;设置gui上面的字体字体大小;
GUI, Add, Text, w%wp% x%xp% Center, ZL音量调节 ;添加gui标题为volume。[其实,也就是第一行添加字体,写字,第二行添加进度条,第三行添加字体数值]
GUI, Font
 GUI Add, Progress,horizontal vProgress x%xp% w%wp% h%hp% c%Bar_Colour% +Background%BackBar_Colour% , % Curr_Vol ;gui添加进度条;
GUI, Font, c%Font_Colour% s13 ;设置gui下面的字体大小;
SoundGet, Vol ;获取当前音量;
 
RegExMatch( Vol, "(?<Percent>\d+)\.", rg ) ;对当前音量格式进行正则匹配处理;目的就是获取音量数值；
GUI, Add, Text, w%wp% x%xp% Center vVol, % rgPercent ;w500
 GUI, Show, NoActivate h%GUi_H% w%GUi_W% x%Gui_X% y%Gui_Y%, Vol_OSD
 
GUI_wR:=GUI_W*1.25
 GUI_HR:=GUI_H*1.5
 WinSet, Region, w%GUI_WR% h%GUI_HR% R10-10 0-0, Vol_OSD
 WinSet, Transparent, %Trans%, Vol_OSD ;设置透明度;
GUI, -Caption +AlwaysOnTop +E0x20 +SysMenu
 }
 
WinSet, Transparent, 255, Vol_OSD ;255为不透明;0为全透明;
SoundSet, % InStr(A_ThisLabel,"+") ? "+1" : "-1", MASTER
 SoundGet, Vol ;再次获取修改后的主音量;
GuiControl,, Progress, % Vol
 RegExMatch( Vol, "(?<Percent>\d+)\.", rg )
 GuiControl,, Vol, % rgPercent
 SetTimer, Fade, -1500
 return
 
Fade: ;设置gui消失时间;
While ( Trans > 0) ;这样做是增加淡出效果;
 { Trans -= 2
 WinSet, Transparent, % Trans, Vol_OSD
Sleep, 5
 }
 GUI,destroy
 winclose,Vol_OSD
Return