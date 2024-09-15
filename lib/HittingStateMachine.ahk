#Requires AutoHotkey v2.0

; The Machine managing the hitting state
class HittingStateMachine {
    __New(hittingRangeHeightFactor := 0.2) {
        this.hittingRangeHeightFactor := hittingRangeHeightFactor
        
        this.initState()
    }

    initState(){
        this.setState(IdleState(this))
    }

    setState(state) {
        if(HasProp(this, "currentState")){
            previoustateName := this.currentState.__Class
        } else {
            previoustateName := "(no state)"
        }
        this.currentState := state
    }

    handleState(){
        this.currentState.handle()
    }

    reset() {
        this.initState()
    }

    setWindowBoundaries(windowWidth, windowHeight){
        this.windowWidth := windowWidth
        this.windowHeight := windowHeight

        this.hittingRangeHeightFactor := 0.2
        this.hittingRangeYSize := windowHeight * this.hittingRangeHeightFactor
        this.hittingClickRightX := windowWidth
        this.hittingClickRightY := (windowHeight - this.hittingRangeYSize) * 0.5
    }

    areWindowBoundriesSet(){
        return HasProp(this, "windowWidth") and HasProp(this, "windowHeight") and HasProp(this, "hittingClickRightX") and HasProp(this, "hittingClickRightY")
    }
}

; The way your current state looks like while you are hitting
class HittingStateMachineState {
    __New(context) {
        this.context := context
        this.startTime := A_TickCount
    }

    ; Sets the context's state
    changeState(state){
        this.context.setState(state)
    }

    ; Needs to be implemented in subclasses
    handle(){
    }

    ; Get's elapsed time in ms
    getElapsedTime(){
        elapsedTime := A_TickCount - this.startTime
        return A_TickCount - this.startTime
    }

    hit(){
        Click(this.hittingClickX, this.hittingClickY + this.hittingRangeYSize * Sin(this.getElapsedTime()))
    }

    hittingRangeYSize => this.context.hittingRangeYSize
    hittingClickX => this.context.hittingClickRightX
    hittingClickY => this.context.hittingClickRightY
}


; State implementations

; Standing next to fence where enemies are behind
class IdleState extends HittingStateMachineState {
    handle(){
        this.startHitting()
    }

    startHitting(){
        this.changeState(HittingState(this.context))
    }
}

; Start hitting in one direction
class HittingState extends HittingStateMachineState {
    handle(){
        this.hit()
        sleep(10)
    }
}
