
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
    parameter desired.
    parameter actual.

    set input to 0.
    if(self[PID_lastTime] = 0){
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

SAS off.


set runwayPosition to LATLNG(-0.0488, -74.52).
set runway to runwayPosition.

set headingPID to PID(0.1,3,4).
set rollPID  to PID(0.1,0.2,0.2).
set timestep to 0.1.
lock steering to heading(90, 30).

until 1 = 0 {


	set maxSpeed to  runway:distance/130 + 70.
	set desiredAltitude to 20000 * ((runway:distance/100000))^2 + 1000.

	if(runway:distance < 10000){
		set desiredAltitude to 1000 * ((runway:distance/10000))^2 + 80.
	}
	set altitudeDiff to desiredAltitude - SHIP:altitude.
	set desiredPitch to altitudeDiff/desiredAltitude * 30.

	set headingDiff to runway:heading - 90.
	set now to TIME:SECONDS.

	set kmOut to runway:distance/1000.

    set out to     PIDtick(headingPID, now, 0, headingDiff).
	set desiredRoll to -min(20, max(-20, -out * kmOut)).

	set currentRoll to (90 - VANG(SHIP:up:vector, SHIP:FACING:STARVECTOR)).
    set rollOut to PIDtick(rollPID, now, currentRoll, desiredRoll).



	lock steering to heading(90, desiredPitch).

	set ship:control:roll to rollOut.

	clearscreen.
    print "Heading Diff: " + headingDiff.
    print "Heading out: " + -out.

	print "--".
	print "Current Roll: " + currentRoll.
	print "Roll Desired: " + desiredRoll.
	print "Roll out:     "  + rollOut.

	print "--".
	print "Distance:     " + runway:distance.


	set rollVector        to ANGLEAXIS(currentRoll,SHIP:facing:forevector) * SHIP:UP:forevector.
	set desiredRollVector to ANGLEAXIS(desiredRoll,SHIP:facing:forevector) * SHIP:UP:forevector.

	set aboveShip to SHIP:UP:forevector.
	set controlRollVector to -ship:control:roll * SHIP:UP:topvector.

	set rollDraw to VECDRAWARGS( V(0,0,0), rollVector, RGB(1, 0, 0), "Roll", 5, TRUE ).
	set desiredRollDraw to VECDRAWARGS( V(0,0,0), desiredRollVector, RGB(0, 1, 0), "Desired Roll", 5, TRUE ).
	set controlRollDraw to VECDRAWARGS( aboveShip, controlRollVector, RGB(0, 0, 1), "Control Roll", 5, TRUE ).


	WAIT timestep.
}	


function format {
	parameter p.
	return floor(p*1000)/1000.

}
