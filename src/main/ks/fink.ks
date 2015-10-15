
WAIT 3.

set desiredPitch to 30.
set desiredYaw to 0.
set desiredRoll to 0.

set signalShutdown to 0.
set abortDive to 0.

SAY("Fink Booting Up...").


IF SHIP:ALTITUDE < 75  {



    SAY("Starting takeoff...").
	lock throttle to 1.
	STAGE.
	
	WHEN SHIP:AIRSPEED > 100 THEN lock steering to heading(90, 40).
	WHEN SHIP:ALTITUDE > 500 THEN GEAR OFF.
	WHEN SHIP:ALTITUDE > 9000 THEN lock steering to heading(90, 12).
	
	scheduleDive.
	
	WHEN SHIP:AIRSPEED > 1250 THEN {
		SAY("Shifting to next stage").
		set abortDive to 1.
		lock steering to heading(90, 20).
		STAGE.
		WHEN SHIP:APOAPSIS > 50000 THEN {
			lock steering to heading(90, 10).
		}
	}	
	
	WHEN SHIP:APOAPSIS > 80000 THEN {
		lock throttle to 0.
		WHEN SHIP:ALTITUDE > 65000 THEN {
			lock steering to heading(90, 0).
		}
		WHEN ETA:APOAPSIS < 30 THEN {
			lock throttle to 1 - ETA:APOAPSIS/30.
			WHEN SHIP:PERIAPSIS > 80000 THEN {
				lock throttle to 0.
			}
		}
	
	}
}
until 1 = 0 {
    run fuel.
    WAIT 10.
}

function SAY{
  parameter message.
  HUDTEXT(message, 30, 1, 12, rgb(1,1,1), false).
}   

function scheduleDive{
	WHEN SHIP:ALTITUDE > 19000 and abortDive = 0 THEN {
		SAY("Acceleration dive").
	    lock steering to heading(90, 2).
	    WHEN SHIP:ALTITUDE < 18000 and abortDive = 0 THEN {
			SAY("Dive recover").
	    	lock steering to heading(90, 8).
	    	scheduleDive.
		}
	}	
}

