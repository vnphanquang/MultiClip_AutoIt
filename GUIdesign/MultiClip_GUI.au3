
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>


HotKeySet('^{INS}', 'hot_copyPasteMode')
HotKeySet('{INS}', 'hot_copyPaste')
HotKeySet('{ESC}', 'hot_exitProgram')
HotKeySet('^1', 'hot_selectClip1')
HotKeySet('^2', 'hot_selectClip2')
HotKeySet('^3', 'hot_selectClip3')
HotKeySet('^4', 'hot_selectClip4')
HotKeySet('^5', 'hot_selectClip5')



Global Const $COPY_MODE = 0
Global Const $PASTE_MODE = 1

Global Const $ACTIVE = 1
Global Const $UNACTIVE = 0

Global Const $CLIPSIZE = 5
Global Const $cycleInstruction = "Press ""Cycle"" to enable Cycle Mode." & @CRLF & @CRLF & "Press ""CTRL + INSERT"" to toggle between Copy & Paste mode" & @CRLF & @CRLF & "Press ""Insert"" to either copy or paste, depeding on the mode you're in."
Global Const $selectionInstruction = "Press ""CTRL + INSERT"" to toggle between Copy & Paste mode" & @CRLF & @CRLF & "Press ""Ctrl + NUMBER"" to copy/paste, where NUMBER is 1,2,3,4, or 5."

Global $clipMode = $COPY_MODE
Global $stepMode = $ACTIVE

Global $multiClip[$CLIPSIZE + 1]
Global $multiClipState[$CLIPSIZE + 1]
For $i = 0 To 4 Step +1
	$multiClipState[$i] = $ACTIVE
Next

Global $clipIndex = 0

main()


;-----------------Main-----------------
Func main()

	mainGUI()

	;infinite loop, press ESC to exit
	While 1
		Sleep(50)
	WEnd

EndFunc   ;==>main
;--------------------------------------


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
	Global $modeGroup = GUICtrlCreateGroup("", 7, 24, 345, 57, BitOR($GUI_SS_DEFAULT_GROUP, $BS_CENTER))
	Global $rCycle = GUICtrlCreateRadio("Cycle", 47, 48, 113, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $rSelection = GUICtrlCreateRadio("Selection", 199, 48, 113, 17, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $bInstructions = GUICtrlCreateButton("Instructions", 138, 96, 83, 25)
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

			Case $rCycle
				$stepMode = $ACTIVE

			Case $rSelection
				$stepMode = $UNACTIVE

			Case $bInstructions
				If ($stepMode = $ACTIVE) Then
					MsgBox(0, "Instructions (Cycle Mode)", $cycleInstruction)
				Else
					MsgBox(0, "Instructions (Selection Mode)", $selectionInstruction)
				EndIf

			Case $rCopy
				$clipMode = $COPY_MODE

			Case $rPaste
				$clipMode = $PASTE_MODE

			Case $rClip[0]
				$clipIndex = 0
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!")
				EndIf
			Case $rClip[1]
				$clipIndex = 1
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!")
				EndIf
			Case $rClip[2]
				$clipIndex = 2
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!")
				EndIf
			Case $rClip[3]
				$clipIndex = 3
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!")
				EndIf
			Case $rClip[4]
				$clipIndex = 4
				If ($multiClipState[$clipIndex] = $UNACTIVE) Then
					MsgBox(0, "Unactive Clip", "Caution: chosen clip is unactive." & @CRLF & "Copy into clip or check the ""Active"" box to make it active!")
				EndIf

			Case $cClip[0]
				If BitAND(GUICtrlRead($cClip[0]), $GUI_CHECKED) Then
					$multiClipState[0] = $ACTIVE
				Else
					$multiClipState[0] = $UNACTIVE
					If ($clipIndex = 0) Then
						moveClipIndex()
					EndIf
				EndIf
			Case $cClip[1]
				If BitAND(GUICtrlRead($cClip[1]), $GUI_CHECKED) Then
					$multiClipState[1] = $ACTIVE
				Else
					$multiClipState[1] = $UNACTIVE
					If ($clipIndex = 1) Then
						moveClipIndex()
					EndIf
				EndIf
			Case $cClip[2]
				If BitAND(GUICtrlRead($cClip[2]), $GUI_CHECKED) Then
					$multiClipState[2] = $ACTIVE
				Else
					$multiClipState[2] = $UNACTIVE
					If ($clipIndex = 2) Then
						moveClipIndex()
					EndIf
				EndIf
			Case $cClip[3]
				If BitAND(GUICtrlRead($cClip[3]), $GUI_CHECKED) Then
					$multiClipState[3] = $ACTIVE
				Else
					$multiClipState[3] = $UNACTIVE
					If ($clipIndex = 3) Then
						moveClipIndex()
					EndIf
				EndIf
			Case $cClip[4]
				If BitAND(GUICtrlRead($cClip[4]), $GUI_CHECKED) Then
					$multiClipState[4] = $ACTIVE
				Else
					$multiClipState[4] = $UNACTIVE
					If ($clipIndex = 4) Then
						moveClipIndex()
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
	Global $QuickBoard = GUICreate("QuickBoard", 231, 105, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME), -1, $Main)

	Local $mOptions = GUICtrlCreateMenu("&Options")
	Local $smStayOnTop = GUICtrlCreateMenuItem("&Stay On Top", $mOptions)
	Local $smBack = GUICtrlCreateMenuItem("&Back To Manager", $mOptions)
	Local $mHelp = GUICtrlCreateMenu("&Help")
	Local $smAbout = GUICtrlCreateMenuItem("&About", $mHelp)

	Global $tqClip = GUICtrlCreateEdit("", 80, 8, 139, 17, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_WANTRETURN))
	GUICtrlSetFont(-1, 8, 400, 2, "MS Sans Serif")

	Local $gCycle = GUICtrlCreateGroup("Cycle", 56, 32, 65, 49)
	Global $rqCycle = GUICtrlCreateRadio("I", 64, 48, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $rqSelection = GUICtrlCreateRadio("0", 88, 48, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $gMode = GUICtrlCreateGroup("Mode", 152, 31, 65, 49)
	Global $rqCopy = GUICtrlCreateRadio("C", 160, 47, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $rqPaste = GUICtrlCreateRadio("P", 184, 47, 25, 25, BitOR($GUI_SS_DEFAULT_RADIO, $BS_PUSHLIKE))
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Global $lClip = GUICtrlCreateLabel("1", 52, 5, 25, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE), $WS_EX_STATICEDGE)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")

	Local $bClipPlus = GUICtrlCreateButton("+", 8, 0, 41, 41, $BS_CENTER)
	GUICtrlSetFont(-1, 25, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Press to decrement clip by 1")

	Local $bClipMinus = GUICtrlCreateButton("-", 8, 40, 41, 41, $BS_CENTER)
	GUICtrlSetFont(-1, 40, 400, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Press to increment clip by 1")

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
				GUISetState(@SW_SHOW, $Main)
				Return

			Case $bClipMinus
				If ($clipIndex > 0) Then
					$clipIndex -= 1
					GUICtrlSetData($lClip, $clipIndex + 1)
					GUICtrlSetData($tqClip, $multiClip[$clipIndex])

					GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
				EndIf


			Case $bClipPlus
				If ($clipIndex < $CLIPSIZE - 1) Then
					$clipIndex += 1
					GUICtrlSetData($lClip, $clipIndex + 1)
					GUICtrlSetData($tqClip, $multiClip[$clipIndex])

					GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
				EndIf

			Case $tqClip
				$multiClip[$clipIndex] = GUICtrlRead($tqClip)

			Case $rqCopy
				$clipMode = $COPY_MODE
			Case $rqPaste
				$clipMode = $PASTE_MODE

			Case $rqCycle
				$stepMode = $ACTIVE

			Case $rqSelection
				$stepMode = $UNACTIVE
		EndSwitch
	WEnd

	GUIDelete()

EndFunc   ;==>quickGUI


;-----------------------------------------------------------GUI-----------------------------------------------------------




;--------------------HOTKEYS-----------------------------------
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
		MsgBox(0, "Unactive Clip", "Chosen clip is unactive. Please pick another clip!")
	Else

		$clipIndex = 0

		GUICtrlSetState($rClip[0], $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetData($lClip, 1)
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
		MsgBox(0, "Unactive Clip", "Chosen clip is unactive. Please pick another clip!")
	Else

		$clipIndex = 1

		GUICtrlSetState($rClip[1], $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetData($lClip, 2)
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
		MsgBox(0, "Unactive Clip", "Chosen clip is unactive. Please pick another clip!")
	Else

		$clipIndex = 2

		GUICtrlSetState($rClip[2], $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetData($lClip, 3)
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
		MsgBox(0, "Unactive Clip", "Chosen clip is unactive. Please pick another clip!")
	Else

		$clipIndex = 3

		GUICtrlSetState($rClip[3], $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetData($lClip, 4)
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
		MsgBox(0, "Unactive Clip", "Chosen clip is unactive. Please pick another clip!")
	Else

		$clipIndex = 4

		GUICtrlSetState($rClip[4], $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetData($lClip, 5)
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

		GUICtrlSetState($rPaste, $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetState($rqPaste, $GUI_CHECKED)
		EndIf

	Else
		$clipMode = $COPY_MODE

		GUICtrlSetState($rCopy, $GUI_CHECKED)
		If BitAND(WinGetState("QuickBoard"), 1) Then
			GUICtrlSetState($rqCopy, $GUI_CHECKED)
		EndIf
	EndIf

EndFunc   ;==>hot_copyPasteMode


;--------------------HELPERS-----------------------------------
Func copy()

	Local $tempClip = ClipGet()
	Send('^c')
	$multiClip[$clipIndex] = ClipGet()
	$multiClipState[$clipIndex] = $ACTIVE
	ClipPut($tempClip)

	GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
	GUICtrlSetData($tClip[$clipIndex], $multiClip[$clipIndex])
	If BitAND(WinGetState("QuickBoard"), 1) Then
		GUICtrlSetState($lClip, $clipIndex + 1)
		GUICtrlSetData($tqClip, $multiClip[$clipIndex])
	EndIf

EndFunc   ;==>copy

Func copyStep() ;INSERT with SCROLLOCK off

	copy()
	moveClipIndex()

EndFunc   ;==>copyStep

Func paste()

	Switch $multiClipState[$clipIndex]
		Case $ACTIVE
			Send($multiClip[$clipIndex])
		Case $UNACTIVE
			;skips Unvacated clip?
	EndSwitch

EndFunc   ;==>paste

Func pasteStep() ;INSERT with SCROLLOCK on

	paste()
	moveClipIndex()

EndFunc   ;==>pasteStep

Func moveClipIndex()

	If ($clipIndex = $CLIPSIZE) Then
		$clipIndex = 0
	Else
		$clipIndex += 1
	EndIf

	If ($multiClipState[$clipIndex] = $UNACTIVE) Then
		If (isActiveClipboard()) Then
			moveClipIndex()
		Else
			MsgBox(0, "Unactive Clipboard", "Caution: all clips are unactive!")
		EndIf

	EndIf

	GUICtrlSetState($rClip[$clipIndex], $GUI_CHECKED)
	If BitAND(WinGetState("QuickBoard"), 1) Then
		GUICtrlSetState($lClip, $clipIndex + 1)
	EndIf


EndFunc   ;==>moveClipIndex

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


Func checkState()

	Local $retString
	For $i = 0 To 4 Step +1
		$retString &= "Clip " & $i & "is " & $multiClipState[$i] & @CRLF
	Next

	MsgBox(0, "State Checking", $retString)

EndFunc   ;==>checkState


