local PID_Kp to 0.
local PID_Ki to 1.
local PID_Km to 2.
local PID_lastTime to 3.
local PID_oldI to 4.
local PID_oldP to 5.

declare function PID {
    parameter Kp.
    parameter Ki.
    parameter Km.

    set self to list(Kp, Ki, Km, 0, 0, 0).
    return self.
}

declare function PIDtick {
    parameter self.
    parameter now.
    parameter desired,
    parameter actual.

    set input to 0.
    if(lastTime = 0){
        set self[PID_lastTime] to now.
    }
    else {
        set dT to now - self[PID_lastTime].
        set P to desired - actual.
        set D to (P - self[PID_oldP])/dT.
        set I to (self[PID_oldI] + P)*dT.
        set input to self[PID_Kp] * P + self[PID_Ki] * I + self[PID_Km] * D.
        set self[PID_lastTime] to now.
        set self[PID_oldP] to P.
        set self[PID_oldI] to I.
    }

    return input.
}