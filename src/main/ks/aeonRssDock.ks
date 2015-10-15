


SET aeon TO VESSEL("Aeon 3").

set lastTime to TIME:SECONDS - 1.
set lastPitch to 0.
set lastYaw to 0.
set lastRoll to 0.

set lastSteerMag to 0.
SET SHIP:CONTROL:NEUTRALIZE to True.


until 1 = 0 {

	set now to TIME:SECONDS.
	set elapsed to now - lastTime.

	set rotate to aeon:facing:topvector - ship:facing:forevector.

	set dir to ROTATEFROMTO(ship:facing:forevector, ship:prograde:forevector).

	//set rotateDraw to VECDRAWARGS( v(0,0,0), rotate * 5, RGB(0, 1, 0), "Target Rotation", 5, TRUE ).
	//set aeonFacingDraw to VECDRAWARGS( v(0,0,0), aeon:facing:topvector * 5, RGB(0, 1, 0), "Target Facing", 5, TRUE ).
	//set meFacingDraw to VECDRAWARGS( v(0,0,0), ship:facing:forevector * 5, RGB(0, 1, 0), "Me Facing", 5, TRUE ).
	//lock steering to v(0,0,0).
	//lock steering to aeon:facing:forevector.



	set pitchAngle to dir:pitch.
	set yawAngle to dir:yaw.
	set rollAngle to dir:roll.
	if(pitchAngle > 180){
		set pitchAngle to -(360 - pitchAngle).
	}
	if(yawAngle > 180){
		set yawAngle to -(360 - yawAngle).
	}
	if(rollAngle > 180){
		set rollAngle to -(360 - rollAngle).
	}
	set pitchChange to (pitchAngle - lastPitch)/elapsed.
	set yawChange   to (yawAngle   - lastYaw)/elapsed.
	set rollChange to  (rollAngle  - lastRoll)/elapsed.
//	set SHIP:CONTROL:PITCH to  pitchAngle/30 + pitchChange/5.
//	set SHIP:CONTROL:YAW   to  -yawAngle/30 -  yawChange/5.
	//set SHIP:CONTROL:ROLL   to  -rollAngle/30 -  rollChange/5.


	set steerDiff to ship:prograde:forevector - ship:facing:forevector.
	set steerChange to (steerDiff:MAG - lastSteerMag)/elapsed.

	set steer to (1 + steerChange*5) * steerDiff.// + steerDiff * steerChange/1.

	lock steering to ship:prograde:forevector.
	set steerDiffDraw   to VECDRAWARGS( v(0,0,0), steerDiff            * 5, RGB(1, 0, 0), "Steer Diff", 5, TRUE ).
	set steerDraw       to VECDRAWARGS( v(0,0,0), steer                * 5, RGB(0, 1, 0), "Steer", 5, TRUE ).
	set steeringDraw    to VECDRAWARGS( v(0,0,0), steering             * 5, RGB(0, 0, 1), "Steering", 5, TRUE ).
	set facingDraw      to VECDRAWARGS( v(0,0,0), facing:forevector    * 5, RGB(1, 0, 1), "Facing", 5, TRUE ).
	set progradeDraw    to VECDRAWARGS( v(0,0,0), prograde:forevector   * 5, RGB(1, 0, 1), "Prograde", 5, TRUE ).



	clearscreen.
	print "Updated".
	print "Pitch Angle:   " + pitchAngle.
	print "Yaw Angle:     " + yawAngle.
	print "Roll Angle:    " + dir:roll.
	print "Pitch Change:  " + pitchChange.


	print "--".
	print "Pitch Control: " + ship:control:pitch.
	print "Yaw Control:   " + ship:control:yaw.




	wait 0.3.

	set lastTime to now.
	set lastPitch to pitchAngle.
	set lastYaw to yawAngle.
	set lastSteerMag to steerDiff:MAG.


}