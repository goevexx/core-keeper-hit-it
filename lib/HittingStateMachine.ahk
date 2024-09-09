#Requires AutoHotkey v2.0

; The Machine managing the hitting state
class HittingStateMachine {
    __New(resetThreshhold := 2000) {
        this.resetThreshhold := resetThreshhold
        
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
        if(this.currentState.getElapsedTime() > this.resetThreshhold){
            this.reset()
        }  
        this.currentState.handle()
    }

    reset() {
        this.initState()
    }

    setWindowBoundaries(windowWidth, windowHeight){
        this.windowWidth := windowWidth
        this.windowHeight := windowHeight

        this.hittingClickRightX := windowWidth * 0.55
        this.hittingClickRightY := windowHeight * 0.5
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
        Click(this.hittingClickX, this.hittingClickY)
    }

    hittingClickX => this.context.hittingClickRightX
    hittingClickY => this.context.hittingClickRightY
}


; State implementations

; Standing next to the ground on all directions
class IdleState extends HittingStateMachineState {
    handle(){
        this.startHitting()
    }

    startHitting(){
        this.changeState(HittingState(this.context))
    }
}

; No Block in direction
class HittingState extends HittingStateMachineState {
    handle(){
        this.hit()
        sleep(10)
    }
}
