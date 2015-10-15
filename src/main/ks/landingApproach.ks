
SAS off.


set desiredBearing to 0.
set desiredRoll to 0.
set runwayPosition to LATLNG(-0.0488, -74.52).
set runway to runwayPosition.

set logname to "aeon3_" + TIME:SECONDS + ".csv".
	
	
SET advanced to SHIP:PARTSNAMED("asasmodule1-2").
	
for p in advanced {
	set m to p:GETMODULE("ModuleReactionWheel").
	m:DOACTION("deactivate", true).
}
set lastRollDiff to 0.

set lastHeadingDiff to 0.
set timestep to 0.1.

set lastSpeed to 0.
set speedChange to 0.
              
set lastTick to TIME:SECONDS.
set lastMajorTick to lastTick.
set distanceUntilSlowed to 0.


set lastHeadingChange to 0.

until 1 = 0 {
	WAIT timestep.
	
	set now to TIME:SECONDS.
	set timeElapsed to now - lastTick.
	set lastTick to now.
	

	set maxSpeed to  runway:distance/130 + 70.
	set desiredAltitude to 20000 * ((runway:distance/100000))^2 + 1000.

	if(runway:distance < 10000){
		set desiredAltitude to 1000 * ((runway:distance/10000))^2 + 80.
	}
	
	
	set headingDiff to runway:heading - 90.
	set desiredBearing to runway:heading.
	set headingChange to (headingDiff - lastHeadingDiff)/timeElapsed.


	set headingChangeBenefitLimit to 0.8.
	set headingSign to 1.
	if(abs(headingDiff) > 0.00001){
		set headingSign to (abs(headingDiff)/headingDiff).
	}
	set desiredRollBenefit to headingSign *  10 * -headingChange + 1. 
	set desiredRoll to -25	 * headingDiff -  500 * headingChange.

	set altitudeDiff to desiredAltitude - SHIP:altitude.
	set desiredPitch to altitudeDiff/desiredAltitude * 30.
	


	if(ship:altitude< 500){
		GEAR on.
	}

	if(ship:altitude < 300 and runway:distance < 2000){
		set desiredRoll to 0.
		set desiredPitch to 5.
		set desiredBearing to 90.
	}

	
	set currentRoll to (90 - VANG(SHIP:up:vector, SHIP:FACING:STARVECTOR)).
	set rollDiff to (currentRoll - desiredRoll).
	set rollChange to (rollDiff - lastRollDiff)/timeElapsed.
	
	set SHIP:CONTROL:ROLL to (rollDiff/15) + rollChange/15.
	
	if(maxSpeed < SHIP:AIRSPEED or runway:distance < 5000){
		BRAKES on.
	}
	else{
		BRAKES off.
	}

	set rollVector        to ANGLEAXIS(currentRoll,SHIP:facing:forevector) * SHIP:UP:forevector. 
	set desiredRollVector to ANGLEAXIS(desiredRoll,SHIP:facing:forevector) * SHIP:UP:forevector. 
	
	set aboveShip to SHIP:UP:forevector.
	set controlRollVector to -ship:control:roll * SHIP:UP:topvector.

	set rollDraw to VECDRAWARGS( V(0,0,0), rollVector, RGB(1, 0, 0), "Roll", 5, TRUE ).
	set desiredRollDraw to VECDRAWARGS( V(0,0,0), desiredRollVector, RGB(0, 1, 0), "Desired Roll", 5, TRUE ).
	set controlRollDraw to VECDRAWARGS( aboveShip, controlRollVector, RGB(0, 0, 1), "Control Roll", 5, TRUE ).
	
	LOCK STEERING TO HEADING(desiredBearing, desiredPitch).
	clearscreen.
	
	print "Current Roll: " + format(currentRoll).
	print "Desired Roll: " + format(desiredRoll).
	print "Roll Diff:    " + format(rollDiff).
	print "Roll Change:  " + rollChange.
	print "Roll Control: " + SHIP:CONTROL:ROLL.

	print "--".
	print "Desired Pitch:    " + desiredPitch.
	print "Max Speed:        " + maxSpeed.

	print "--".
	print "Runway Distance:       " +  runway:distance.
	print "Runway Heading:        " +  runway:heading.
	print "Runway Heading Diff:   " +  headingDiff.
	print "Runway Heading Change: " +  headingChange.

	
	print "--".
	print "Average Speed Change:  " + speedChange.
	print "Distance until slow:   " + distanceUntilSlowed.
	
	
	
	
	set lastHeadingChange to headingChange.
	set lastHeadingDiff to headingDiff.
	set lastRollDiff to rollDiff.
	
	
}	


function format {
	parameter p.
	return floor(p*1000)/1000.

}
