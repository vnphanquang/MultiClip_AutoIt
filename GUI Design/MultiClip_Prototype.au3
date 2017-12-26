
HotKeySet('^{INS}', 'hot_clearAll')
HotKeySet('{INS}', 'hot_copyPaste')
HotKeySet('{ESC}', 'hot_exitProgram')
HotKeySet('^1', 'hot_selectClip1')
HotKeySet('^2', 'hot_selectClip2')
HotKeySet('^3', 'hot_selectClip3')
HotKeySet('^4', 'hot_selectClip4')
HotKeySet('^5', 'hot_selectClip5')

main()

Func main()
	Global Const $ACTIVE = 1
	Global Const $UNACTIVE = 0
	Global Const $CLIPSIZE = 5

	Global $stepMode = $ACTIVE

	Global $multiClip[$CLIPSIZE + 1]
	Global $multiClipState[$CLIPSIZE + 1]
	For $i = 0 To 4 Step +1
		$multiClipState[$i] = $ACTIVE
	Next
	Global $clipIndex = 0

	;infinite loop, press ESC to exit
	While 1
		Sleep(50)
	WEnd

EndFunc   ;==>main


;--------------------HOTKEYS-----------------------------------
Func hot_copyPaste()
	Local $scrollStatus = _GetScrollLock()

	If ($stepMode = $ACTIVE) Then
		If ($scrollStatus = $ACTIVE) Then
			pasteStep()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copyStep()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	ElseIf ($stepMode = $UNACTIVE) Then
		;press CTRL + number to copy or paste
		;ScrollLock On == Paste Mode
		;ScrollLock off == Copy Mode
	Else
		MsgBox(0, "ERROR", "STEPMODE STATUS UNKNOWN!")
	EndIf

EndFunc   ;==>hot_copyPaste

Func hot_clearAll()

	clearAllClips()

EndFunc   ;==>hot_clearAll

Func hot_exitProgram()

	Exit

EndFunc   ;==>hot_exitProgram

Func hot_selectClip1()

	$clipIndex = 0

	If ($stepMode = $UNACTIVE) Then
		Local $scrollStatus = _GetScrollLock()
		If ($scrollStatus = $ACTIVE) Then
			paste()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copy()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	EndIf

EndFunc   ;==>hot_selectClip1

Func hot_selectClip2()

	$clipIndex = 1

	If ($stepMode = $UNACTIVE) Then
		Local $scrollStatus = _GetScrollLock()
		If ($scrollStatus = $ACTIVE) Then
			paste()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copy()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	EndIf

EndFunc   ;==>hot_selectClip2

Func hot_selectClip3()

	$clipIndex = 2

	If ($stepMode = $UNACTIVE) Then
		Local $scrollStatus = _GetScrollLock()
		If ($scrollStatus = $ACTIVE) Then
			paste()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copy()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	EndIf

EndFunc   ;==>hot_selectClip3

Func hot_selectClip4()

	$clipIndex = 3
	If ($stepMode = $UNACTIVE) Then
		Local $scrollStatus = _GetScrollLock()
		If ($scrollStatus = $ACTIVE) Then
			paste()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copy()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	EndIf

EndFunc   ;==>hot_selectClip4

Func hot_selectClip5()

	$clipIndex = 4
	If ($stepMode = $UNACTIVE) Then
		Local $scrollStatus = _GetScrollLock()
		If ($scrollStatus = $ACTIVE) Then
			paste()
		ElseIf ($scrollStatus = $UNACTIVE) Then
			copy()
		Else
			MsgBox(0, "UNKNOWN", "SCROLLOCK STATUS UNKNOWN!")
		EndIf
	EndIf

EndFunc   ;==>hot_selectClip5

;--------------------HELPERS-----------------------------------
Func copy()

	Local $tempClip = ClipGet()
	Send('^c')
	$multiClip[$clipIndex] = ClipGet()
	$multiClipState[$clipIndex] = $ACTIVE
	ClipPut($tempClip)

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

EndFunc   ;==>moveClipIndex

Func clearAllClips()

	For $index = 0 To $CLIPSIZE
		$multiClip[$index] = ""
		$multiClipState[$index] = $UNACTIVE
	Next

EndFunc   ;==>clearAllClips

Func _GetScrollLock()

	Local Const $VK_SCROLL = 0x91
	Local $ret
	$ret = DllCall("user32.dll", "long", "GetKeyState", "long", $VK_SCROLL)
	Return $ret[0]

EndFunc   ;==>_GetScrollLock
