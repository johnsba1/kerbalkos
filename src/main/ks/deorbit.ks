parameter orbitAngle.
parameter periapsis.
parameter hour.


run moveFuelForward.



set runwayPosition to LATLNG(-0.040557, -74.691111).
set runway to LATLNG(-0.040557, -74.691111).


set done to 0.

SAS off.

set WARP to 3.
WHEN SHIP:LONGITUDE > orbitAngle and SHIP:LONGITUDE < orbitAngle + 2 and (TIME:HOUR >= hour or TIME:HOUR <= mod(hour + 1, 6)) THEN{

	set WARP to 0.
	lock steering to -velocity:surface.
	
	WHEN VANG(SHIP:PROGRADE:forevector, SHIP:FACING:forevector) > 179 THEN {
		lock throttle to 1.
		WHEN SHIP:PERIAPSIS < entryPeriapsis THEN {
			lock throttle to 0.
			set done to 1.
		}
	}
} 

until done = 1 {
    wait 1.
}


run landingApproach.