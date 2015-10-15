

set angle to 0.
set maxAngle to 45.
set ship:control:neutralize to true.
set ship:control:pitch to 1.

until abs(90) - abs(angle) < 0{


    set vDir to VDOT(VECTOREXCLUDE(ship:prograde:starvector, ship:facing:forevector), prograde:topvector).
    set sign to vDir/abs(vDir).

    set myPitch to sign * VANG(ship:prograde:forevector, VECTOREXCLUDE(ship:prograde:starvector, ship:facing:forevector)).


    LOG myPitch + "," + TIME:SECONDS to  "collect.csv".
    set angle to myPitch.


    WAIT 0.01.
}

set ship:control:neutralize to true.