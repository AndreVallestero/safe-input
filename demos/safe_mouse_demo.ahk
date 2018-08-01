; ################ Optimisations ################
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
#SingleInstance force
ListLines Off
Process, Priority, , H
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include ..\safe_input.ahk

Pgup::
	MouseGetPos, targetX, targetY
	return
	
Pgdn::
	SafeMouseMove(targetX, targetY)
	return
	
End::
	ExitApp 
	return 