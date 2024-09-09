#SingleInstance Force
#Include "lib/HittingStateMachine.ahk"

readyToStart := false
startHitting := false
instructions := "1. Open Core Keeper.`n2. Fill up your inventory with swords. They will break.`n3. Move your character to a position so that an active spawner(e.g. with an mushroom statue inside) is on your right side behind a fence.`n4. Make sure the spawner is also completely fenced.`n5. Put a sword into your hand.`n6. Press CTRL + F to get started power up your combat skill.`n`nControls:`nPress CTRL + F to stop/start the procedure`nPress CTRL + Q to quit this script"

resultOk := MsgBox("Hey there core keepers`n`nIt's a nice day to go hitting, ain't it? Huho.`n`n" . instructions, "Core Keeper - HitIt", 0)
readyToStart := resultOk = "OK"
if !readyToStart
    ExitApp

hittingMachine := HittingStateMachine()
Loop {
    if (!startHitting) {
        continue
    }

    If !WinExist("Core Keeper") {
        MsgBox("Core Keeper is not open. You need to obey:`n`n" . instructions, "HitIt - Core Keeper not open", "OK")
        startHitting := false
        hittingMachine.reset()
        continue
    }
    If !WinActive("Core Keeper") {
        yesResult := MsgBox("Core Keeper needs to be your active window.`n`nWait, let me activate it...", "HitIt - Core Keeper not active", "YesNo")
        if (yesResult = "Yes"){
            WinActivate("Core Keeper")
            startHitting := true
        } else if (yesResult = "No"){
            startHitting := false
        }
        hittingMachine.reset()
        continue
    } else if (!hittingMachine.areWindowBoundriesSet()){
        setMachinesWindowBoundries()
    }

    hittingMachine.handleState()
}

setMachinesWindowBoundries(){
    global hittingMachine
    WinGetPos(&WinX, &WinY, &WinW, &WinH)
    hittingMachine.setWindowBoundaries(WinW, WinH)
}

$^f::{
    global
    if(readyToStart) {
        startHitting := !startHitting
        hittingMachine.reset()
    }
}
$^q::ExitApp