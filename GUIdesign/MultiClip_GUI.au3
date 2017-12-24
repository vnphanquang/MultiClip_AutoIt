#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

;-----------------------------------------------Declaration & Initialization-----------------------------------------------
HotKeySet('^{INS}', 'hot_copyPasteMode')
HotKeySet('{INS}', 'hot_copyPaste')
HotKeySet('{ESC}', 'hot_exitProgram')
HotKeySet('^1', 'hot_selectClip1')
HotKeySet('^2', 'hot_selectClip2')
HotKeySet('^3', 'hot_selectClip3')
HotKeySet('^4', 'hot_selectClip4')
HotKeySet('^5', 'hot_selectClip5')

Global Const $STEP_ON_INSTRUCTION = "Press ""Cycle"" to enable Cycle Mode." & @CRLF & @CRLF & "Press ""CTRL + INSERT"" to toggle between Copy & Paste mode" & @CRLF & @CRLF & "Press ""Insert"" to either copy or paste, depeding on the mode you're in."
Global Const $STEP_OFF_INSTRUCTION = "Press ""CTRL + INSERT"" to toggle between Copy & Paste mode" & @CRLF & @CRLF & "Press ""Ctrl + NUMBER"" to copy/paste, where NUMBER is 1,2,3,4, or 5."
Global Const $UNACTIVE_CLIP_MESSAGE = "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!"
Global Const $UNACTIVE_CLIP_HOTKEY_MESSAGE = "Chosen clip is unactive. Please pick another clip!"

Global Const $WIN_STATE_VISIBLE = 2
Global Const $COPY_MODE = 0
Global Const $PASTE_MODE = 1
Global Const $ACTIVE = 1
Global Const $UNACTIVE = 0

Global Const $CLIPSIZE = 5

Global $clipMode = $COPY_MODE
Global $stepMode = $ACTIVE

Global $switchMode = $UNACTIVE
Global $switchIndex

Global $multiClip[$CLIPSIZE + 1]
Global $multiClipState[$CLIPSIZE + 1]
For $i = 0 To 4 Step +1
	$multiClipState[$i] = $ACTIVE
Next

Global $clipIndex = 0
;-----------------------------------------------Declaration & Initialization-----------------------------------------------

main()

;-----------------------------------------------------------Main-----------------------------------------------------------
Func main()

	mainGUI()

	;infinite loop, press ESC or click on x on GUI to exit
	While 1
		Sleep(50)
	WEnd

EndFunc   ;==>main
;-----------------------------------------------------------Main-----------------------------------------------------------

;-----------------------------------------------------------GUI-----------------------------------------------------------
Func mainGUI()

	Opt("GUIResizeMode", $GUI_DOCKAUTO)
	Opt("TrayMenuMode", 1)
	#Region ### START Koda GUI section ### Form=c:\users\zelda\desktop\multiclip\koda1.kxf
	Global $Main = GUICreate("MultiClip -Clipboard Manager", 359, 600, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))

	Local $mOptions = GUICtrlCreateMenu("&Options")
	Local $smStayOnTop = GUICtrlCreateMenuItem("&Stay On Top", $mOptions)
	Local $smQuickboard = GUICtrlCreateMenuItem("&QuickBoard", $mOptions)
	Local $mHelp = GUICtrlCreateMenu("&Help")
	Local $smAbout = GUICtrlCreateMenuItem("&About", $mHelp)

	TraySetIcon("", -1)
	TraySetClick("0")
	$tmAbout = TrayCreateItem("&About")
	$tmManager = TrayCreateItem("&Manager")
	$tmExit = TrayCreateItem("&Exit")

	$clipGroup = GUICtrlCreateGroup("Clipboard", 7, 136, 345, 425, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
	Global $tClip[$CLIPSIZE + 1]
	$tClip[0] = GUICtrlCreateEdit("", 79, 208, 201, 41, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	$tClip[1] = GUICtrlCreateEdit("", 79, 272, 201, 41, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	$tClip[2] = GUICtrlCreateEdit("", 79, 336, 201, 41, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	$tClip[3] = GUICtrlCreateEdit("", 79, 400, 201, 41, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")
	$tClip[4] = GUICtrlCreateEdit("", 79, 464, 201, 41, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetData(-1, "")

	Global $rClip[$CLIPSIZE + 1]
	$rClip[0] = GUICtrlCreateRadio("Clip 1", 15, 208, 59, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	$rClip[1] = GUICtrlCreateRadio("Clip 2", 15, 272, 59, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	$rClip[2] = GUICtrlCreateRadio("Clip 3", 15, 336, 59, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	$rClip[3] = GUICtrlCreateRadio("Clip 4", 15, 400, 59, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	$rClip[4] = GUICtrlCreateRadio("Clip 5", 15, 464, 59, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))

	Global $bEdit[$CLIPSIZE + 1]
	$bEdit[0] = GUICtrlCreateButton("Expand", 15, 232, 59, 17)
	$bEdit[1] = GUICtrlCreateButton("Expand", 15, 296, 59, 17)
	$bEdit[2] = GUICtrlCreateButton("Expand", 15, 360, 59, 17)
	$bEdit[3] = GUICtrlCreateButton("Expand", 15, 424, 59, 17)
	$bEdit[4] = GUICtrlCreateButton("Expand", 15, 488, 59, 17)

	Global $cClip[$CLIPSIZE + 1]
	$cClip[0] = GUICtrlCreateCheckbox("Active", 287, 208, 49, 41)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cClip[1] = GUICtrlCreateCheckbox("Active", 287, 272, 49, 41)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cClip[2] = GUICtrlCreateCheckbox("Active", 287, 336, 49, 41)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cClip[3] = GUICtrlCreateCheckbox("Active", 287, 400, 49, 41)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$cClip[4] = GUICtrlCreateCheckbox("Active", 287, 464, 49, 41)
	GUICtrlSetState(-1, $GUI_CHECKED)

	$bClearAll = GUICtrlCreateButton("Clear All", 50, 520, 257, 25)

	Global $cpGroup = GUICtrlCreateGroup("", 14, 144, 329, 41)
	Global $rPaste = GUICtrlCreateRadio("Paste", 198, 160, 113, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	Global $rCopy = GUICtrlCreateRadio("Copy", 46, 160, 113, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUIStartGroup()
	Global $stepGroup = GUICtrlCreateGroup("Settings", 7, 24, 345, 105, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
	Global $rStepOn = GUICtrlCreateRadio("ON", 111, 48, 57, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $rStepOff = GUICtrlCreateRadio("OFF", 183, 48, 57, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	Global $bInstructions = GUICtrlCreateButton("Instructions", 255, 48, 75, 17)
	Global $lStep = GUICtrlCreateLabel("Cycle Mode:", 23, 48, 74, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

	GUIStartGroup()
	Global $bSwitch = GUICtrlCreateButton("X", 295, 88, 35, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Global $lSwitch = GUICtrlCreateLabel("Switch Mode:", 23, 88, 81, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	Global $rSwitchOn = GUICtrlCreateRadio("ON", 111, 88, 57, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	Global $rSwitchOff = GUICtrlCreateRadio("OFF", 183, 88, 57, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $lSwitch = GUICtrlCreateLabel("Index:", 255, 88, 39, 17, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetState(@SW_SHOW)

	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $smStayOnTop
				If BitAND(GUICtrlRead($smStayOnTop), $GUI_UNCHECKED) Then
					GUICtrlSetState($smStayOnTop, $GUI_CHECKED)
					WinSetOnTop("[ACTIVE]", "", 1)
				Else
					GUICtrlSetState($smStayOnTop, $GUI_UNCHECKED)
					WinSetOnTop("[ACTIVE]", "", 0)
				EndIf

			Case $smQuickboard
				GUISetState(@SW_HIDE, $Main)
				quickGUI()

			Case $rStepOn
				$stepMode = $ACTIVE

			Case $rStepOff
				$stepMode = $UNACTIVE

			Case $bInstructions
				If ($stepMode = $ACTIVE) Then
					MsgBox(0, "Instructions (Cycle ON)", $STEP_ON_INSTRUCTION)
				Else
					MsgBox(0, "Instructions (Cycle OFF)", $STEP_OFF_INSTRUCTION)
				EndIf

			Case $rSwitchOn
				$switchMode = $ACTIVE
				GUICtrlSetState($bSwitch, $GUI_ENABLE)

			Case $rSwitchOff
				$switchMode = $UNACTIVE
				GUICtrlSetState($bSwitch, $GUI_DISABLE)

			Case $bSwitch
				moveIndex($switchIndex, False)
				GUICtrlSetData($bSwitch, $switchIndex + 1)

			Case $rCopy
				$clipMode = $COPY_MODE

			Case $rPaste
				$clipMode = $PASTE_MODE

			Case $rClip[0]
				$clipIndex = 0
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_MESSAGE)
				EndIf
			Case $rClip[1]
				$clipIndex = 1
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_MESSAGE)
				EndIf
			Case $rClip[2]
				$clipIndex = 2
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_MESSAGE)
				EndIf
			Case $rClip[3]
				$clipIndex = 3
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_MESSAGE)
				EndIf
			Case $rClip[4]
				$clipIndex = 4
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_MESSAGE)
				EndIf

			Case $cClip[0]
				If BitAND(GUICtrlRead($cClip[0]), $GUI_CHECKED) Then
					$multiClipState[0] = $ACTIVE
				Else
					$multiClipState[0] = $UNACTIVE
					If ($clipIndex = 0) Then
						moveIndex($clipIndex, True)
					EndIf
				EndIf
			Case $cClip[1]
				If BitAND(GUICtrlRead($cClip[1]), $GUI_CHECKED) Then
					$multiClipState[1] = $ACTIVE
				Else
					$multiClipState[1] = $UNACTIVE
					If ($clipIndex = 1) Then
						moveIndex($clipIndex, True)
					EndIf
				EndIf
			Case $cClip[2]
				If BitAND(GUICtrlRead($cClip[2]), $GUI_CHECKED) Then
					$multiClipState[2] = $ACTIVE
				Else
					$multiClipState[2] = $UNACTIVE
					If ($clipIndex = 2) Then
						moveIndex($clipIndex, True)
					EndIf
				EndIf
			Case $cClip[3]
				If BitAND(GUICtrlRead($cClip[3]), $GUI_CHECKED) Then
					$multiClipState[3] = $ACTIVE
				Else
					$multiClipState[3] = $UNACTIVE
					If ($clipIndex = 3) Then
						moveIndex($clipIndex, True)
					EndIf
				EndIf
			Case $cClip[4]
				If BitAND(GUICtrlRead($cClip[4]), $GUI_CHECKED) Then
					$multiClipState[4] = $ACTIVE
				Else
					$multiClipState[4] = $UNACTIVE
					If ($clipIndex = 4) Then
						moveIndex($clipIndex, True)
					EndIf
				EndIf

			Case $tClip[0]
				$multiClip[0] = GUICtrlRead($tClip[0])
			Case $tClip[1]
				$multiClip[1] = GUICtrlRead($tClip[0])
			Case $tClip[2]
				$multiClip[2] = GUICtrlRead($tClip[0])
			Case $tClip[3]
				$multiClip[3] = GUICtrlRead($tClip[0])
			Case $tClip[4]
				$multiClip[4] = GUICtrlRead($tClip[0])

			Case $bClearAll
				clearAllClips()

		EndSwitch
	WEnd

	GUIDelete()

EndFunc   ;==>mainGUI


Func quickGUI()

	Opt("GUIResizeMode", $GUI_DOCKAUTO)
	Opt("TrayMenuMode", 1)

	#Region ### START Koda GUI section ### Form=c:\users\zelda\desktop\multiclip\quickboard.kxf
	Local $QuickBoard = GUICreate("QuickBoard", 231, 105, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME), -1, $Main)

	Local $mOptions = GUICtrlCreateMenu("&Options")
	Local $smStayOnTop = GUICtrlCreateMenuItem("&Stay On Top", $mOptions)
	Local $smBack = GUICtrlCreateMenuItem("&Back To Manager", $mOptions)
	Local $mHelp = GUICtrlCreateMenu("&Help")
	Local $smAbout = GUICtrlCreateMenuItem("&About", $mHelp)

	Global $tqClip = GUICtrlCreateEdit("", 64, 0, 147, 25, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetTip(-1, "Edit to modify clip content!")
	GUICtrlSetFont(-1, 8, 400, "MS Sans Serif")

	Global $bqIndex = GUICtrlCreateButton("1", 24, 0, 25, 25)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Click to increment index!")


	Local $gSwitch = GUICtrlCreateGroup("Switch", 8, 32, 81, 49)
	Global $rqSwitch = GUICtrlCreateRadio("OFF", 16, 48, 33, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_CENTER, $BS_PUSHLIKE))
	GUICtrlSetTip(-1, "Click to toggle Switch Mode")
	Global $bqSwitch = GUICtrlCreateButton("X", 56, 48, 25, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetTip(-1, "Click to increment index to switch")
	GUICtrlCreateGroup("", -99, -99, 1, 1)


	Local $gMode = GUICtrlCreateGroup("Mode", 160, 32, 65, 49)
	Global $rqCopy = GUICtrlCreateRadio("C", 168, 48, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Click to turn on Copy Mode")
	Global $rqPaste = GUICtrlCreateRadio("P", 192, 48, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetTip(-1, "Click to turn on Paste Mode")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $gStep = GUICtrlCreateGroup("Cycle", 96, 32, 57, 49)
	Global $rqStep = GUICtrlCreateRadio("ON", 104, 48, 41, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_CENTER, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlSetTip(-1, "Click to toggle Cycle Mode")
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	refreshQuickGUI()

	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $smStayOnTop
				If BitAND(GUICtrlRead($smStayOnTop), $GUI_UNCHECKED) Then
					GUICtrlSetState($smStayOnTop, $GUI_CHECKED)
					WinSetOnTop("[ACTIVE]", "", 1)
				Else
					GUICtrlSetState($smStayOnTop, $GUI_UNCHECKED)
					WinSetOnTop("[ACTIVE]", "", 0)
				EndIf

			Case $smBack
				GUIDelete()
				GUISetState(@SW_SHOWNA, $Main)
				refreshMainGUI()
				Return

			Case $bqIndex
				moveIndex($clipIndex, True)

			Case $tqClip
				$multiClip[$clipIndex] = GUICtrlRead($tqClip)

			Case $rqCopy
				$clipMode = $COPY_MODE
			Case $rqPaste
				$clipMode = $PASTE_MODE

			Case $rqStep
				quickSwitch($stepMode, $rqStep)

			Case $rqSwitch
				quickSwitch($switchMode, $rqSwitch)
				If ($switchMode = $ACTIVE) Then
					GUICtrlSetState($bqSwitch, $GUI_ENABLE)
				Else
					GUICtrlSetState($bqSwitch, $GUI_DISABLE)
				EndIf

			Case $bqSwitch
				moveIndex($switchIndex, False)
				GUICtrlSetData($bqSwitch, $switchIndex + 1)
		EndSwitch
	WEnd

	GUIDelete()

EndFunc   ;==>quickGUI


;-----------------------------------------------------------GUI-----------------------------------------------------------

;----------------------------------------------------------HOTKEYS----------------------------------------------------------
Func hot_copyPaste()

	If ($stepMode = $ACTIVE) Then
		If ($clipMode = $PASTE_MODE) Then
			pasteStep()
		Else
			copyStep()
		EndIf
	Else
		;press CTRL + number to copy or paste
		;press CTRL + instert to toggle copy/paste mode
	EndIf

EndFunc   ;==>hot_copyPaste

Func hot_exitProgram()

	Exit

EndFunc   ;==>hot_exitProgram

Func hot_selectClip1()

	If ($multiClipState[0] = $UNACTIVE) Then
		MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_HOTKEY_MESSAGE)
	Else

		$clipIndex = 0

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $clipIndex + 1)
			GUICtrlSetData($tqClip, $multiClip[$clipIndex])
		EndIf

		If ($stepMode = $UNACTIVE) Then
			If ($clipMode = $PASTE_MODE) Then
				paste()
			Else
				copy()
			EndIf
		EndIf

	EndIf

EndFunc   ;==>hot_selectClip1

Func hot_selectClip2()

	If ($multiClipState[1] = $UNACTIVE) Then
		MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_HOTKEY_MESSAGE)
	Else

		$clipIndex = 1

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $clipIndex + 1)
			GUICtrlSetData($tqClip, $multiClip[$clipIndex])
		EndIf

		If ($stepMode = $UNACTIVE) Then
			If ($clipMode = $PASTE_MODE) Then
				paste()
			Else
				copy()
			EndIf
		EndIf

	EndIf
EndFunc   ;==>hot_selectClip2

Func hot_selectClip3()

	If ($multiClipState[2] = $UNACTIVE) Then
		MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_HOTKEY_MESSAGE)
	Else

		$clipIndex = 2

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $clipIndex + 1)
			GUICtrlSetData($tqClip, $multiClip[$clipIndex])
		EndIf

		If ($stepMode = $UNACTIVE) Then
			If ($clipMode = $PASTE_MODE) Then
				paste()
			Else
				copy()
			EndIf
		EndIf

	EndIf

EndFunc   ;==>hot_selectClip3

Func hot_selectClip4()

	If ($multiClipState[3] = $UNACTIVE) Then
		MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_HOTKEY_MESSAGE)
	Else

		$clipIndex = 3

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $clipIndex + 1)
			GUICtrlSetData($tqClip, $multiClip[$clipIndex])
		EndIf

		If ($stepMode = $UNACTIVE) Then
			If ($clipMode = $PASTE_MODE) Then
				paste()
			Else
				copy()
			EndIf
		EndIf

	EndIf
EndFunc   ;==>hot_selectClip4

Func hot_selectClip5()

	If ($multiClipState[4] = $UNACTIVE) Then
		MsgBox(0, "Unactive Clip", $UNACTIVE_CLIP_HOTKEY_MESSAGE)
	Else

		$clipIndex = 4

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $clipIndex + 1)
			GUICtrlSetData($tqClip, $multiClip[$clipIndex])
		EndIf

		If ($stepMode = $UNACTIVE) Then
			If ($clipMode = $PASTE_MODE) Then
				paste()
			Else
				copy()
			EndIf
		EndIf

	EndIf

EndFunc   ;==>hot_selectClip5


Func hot_copyPasteMode()

	If ($clipMode = $COPY_MODE) Then
		$clipMode = $PASTE_MODE

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rPaste, $GUI_CHECKED)
		Else
			GUICtrlSetData($rqPaste, $GUI_CHECKED)
		EndIf

	Else
		$clipMode = $COPY_MODE

		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rCopy, $GUI_CHECKED)
		Else
			GUICtrlSetState($rqCopy, $GUI_CHECKED)
		EndIf
	EndIf

EndFunc   ;==>hot_copyPasteMode
;---------------------------------------------------------HOTKEYS---------------------------------------------------------

;---------------------------------------------------------HELPERS---------------------------------------------------------
Func refreshMainGUI()

	If ($clipMode = $COPY_MODE) Then
		GUICtrlSetState($rCopy, $GUI_CHECKED)
	Else
		GUICtrlSetState($rPaste, $GUI_CHECKED)
	EndIf

	If ($stepMode = $ACTIVE) Then
		GUICtrlSetState($rStepOn, $GUI_CHECKED)
	Else
		GUICtrlSetState($rStepOff, $GUI_CHECKED)
	EndIf

	For $i = 0 To 4 Step +1
		GUICtrlSetData($tClip[$i], $multiClip[$i])
	Next

	GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)

EndFunc   ;==>refreshMainGUI

Func refreshQuickGUI()

	If ($clipMode = $COPY_MODE) Then
		GUICtrlSetState($rqCopy, $GUI_CHECKED)
	Else
		GUICtrlSetState($rqPaste, $GUI_CHECKED)
	EndIf

	If ($stepMode = $ACTIVE) Then
		GUICtrlSetData($rqStep, "ON")
		GUICtrlSetState($rqStep, $GUI_CHECKED)
	Else
		GUICtrlSetData($rqStep, "OFF")
		GUICtrlSetState($rqStep, $GUI_UNCHECKED)
	EndIf

	If ($switchMode = $ACTIVE) Then
		GUICtrlSetData($rqSwitch, "ON")
		GUICtrlSetState($rqSwitch, $GUI_CHECKED)
	Else
		GUICtrlSetData($rqSwitch, "OFF")
		GUICtrlSetState($rqSwitch, $GUI_UNCHECKED)
	EndIf

	GUICtrlSetData($bqSwitch, $switchIndex + 1)

	GUICtrlSetData($bqIndex, $clipIndex + 1)
	GUICtrlSetData($tqClip, $multiClip[$clipIndex])

EndFunc   ;==>refreshQuickGUI

Func quickSwitch(ByRef $mode, ByRef $buttonID)

	If ($mode = $ACTIVE) Then
		$mode = $UNACTIVE
		GUICtrlSetData($buttonID, "OFF")
		GUICtrlSetState($buttonID, $GUI_UNCHECKED)
	Else
		$mode = $ACTIVE
		GUICtrlSetData($buttonID, "ON")
		GUICtrlSetState($buttonID, $GUI_CHECKED)
	EndIf

EndFunc   ;==>quickSwitch

Func copy()

	Local $tempClip = ClipGet()
	Send('^c')
	$multiClip[$clipIndex] = ClipGet()
	$multiClipState[$clipIndex] = $ACTIVE
	ClipPut($tempClip)

	If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
		GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
		GUICtrlSetData($tClip[$clipIndex], $multiClip[$clipIndex])
	Else
		GUICtrlSetData($bqIndex, $clipIndex + 1)
		GUICtrlSetData($tqClip, $multiClip[$clipIndex])
	EndIf

EndFunc   ;==>copy

Func copyStep()

	copy()
	If (moveIndex($clipIndex, True) = $switchIndex And $switchMode = $ACTIVE) Then
		hot_copyPasteMode()
	EndIf

EndFunc   ;==>copyStep

Func paste()

	Switch $multiClipState[$clipIndex]
		Case $ACTIVE
			Send($multiClip[$clipIndex])
		Case $UNACTIVE
			;skips Unvacated clip?
	EndSwitch

EndFunc   ;==>paste

Func pasteStep()

	paste()
	If (moveIndex($clipIndex, True) = $switchIndex And $switchMode = $ACTIVE) Then
		hot_copyPasteMode()
	EndIf

EndFunc   ;==>pasteStep

Func moveIndex(ByRef $indexToMove, $updateGUI)

	If ($indexToMove + 1 = $CLIPSIZE) Then
		$indexToMove = 0
	Else
		$indexToMove += 1
	EndIf

	If ($multiClipState[$indexToMove] = $UNACTIVE) Then
		If (isActiveClipboard()) Then
			moveIndex($indexToMove, $updateGUI)
		Else
			MsgBox(0, "Unactive Clipboard", "Caution: all clips are unactive!")
		EndIf

	EndIf

	If ($updateGUI = True) Then
		If BitAND(WinGetState("MultiClip -Clipboard Manager"), $WIN_STATE_VISIBLE) Then
			GUICtrlSetState($rClip[$indexToMove], $GUI_CHECKED)
		Else
			GUICtrlSetData($bqIndex, $indexToMove + 1)
			GUICtrlSetData($tqClip, $multiClip[$indexToMove])
		EndIf
	EndIf

	Return $indexToMove

EndFunc   ;==>moveIndex

Func isActiveClipboard()

	For $i = 0 To 4 Step +1
		If ($multiClipState[$i] = $ACTIVE) Then
			Return True
		EndIf
	Next

	Return False

EndFunc   ;==>isActiveClipboard

Func clearAllClips()

	For $index = 0 To $CLIPSIZE
		$multiClip[$index] = ""
		GUICtrlSetData($tClip[$index], "")
		$multiClipState[$index] = $ACTIVE
	Next

EndFunc   ;==>clearAllClips


Func checkState() ;Debugging helpers

	Local $retString
	For $i = 0 To 4 Step +1
		$retString &= "Clip " & $i & "is " & $multiClipState[$i] & @CRLF
	Next

	MsgBox(0, "State Checking", $retString)

EndFunc   ;==>checkState
;---------------------------------------------------------HELPERS---------------------------------------------------------
