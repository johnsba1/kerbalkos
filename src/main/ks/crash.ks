
declare function cosRad {
    parameter input.
    return cos(CONSTANT:RadToDeg * input).
}
declare function sinRad {
    parameter input.
    return sin(CONSTANT:RadToDeg * input).
}

declare function arccosRad {
    parameter input.
    return CONSTANT:DegToRad * arccos(input).
}
declare function arcsinRad {
    parameter input.
    return CONSTANT:DegToRad * arcsin(input).
}
declare function ShipTWR
{
    set mth to SHIP:MAXTHRUST. // (depends on fixed kOS issue 940)
    set r to SHIP:ALTITUDE+SHIP:BODY:RADIUS.
    set w to SHIP:MASS * SHIP:BODY:MU / r / r.
    return mth/w.
}

set descentPid to PIDLOOP(1,1,1, 0, 1).
set landing to 0.
set stopping to 0.
set finalTouchdown to 0.
set landingHeight to 84.
set vehicleHeight to alt:radar.

wait 1.
set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.

lock throttle to 1.
lock steering to heading(90,89).

stage.

until ship:apoapsis > 8000 {}

lock throttle to 0.
lock steering to heading(90,90).

until ship:verticalSpeed < -3 {}

set isp to 0.
LIST ENGINES IN allEngines.
FOR eng IN allEngines {
    set isp to eng:SEALEVELISP.
}.
set T to ship:maxthrust.
set ve to isp * 9.81.
set mdot to T / (isp * 9.81).
lock newBurnTime to (ship:mass * ve / T) * (1 - CONSTANT:E^(ship:verticalSpeed/ve)).
lock burnMass to mdot * newBurnTime.
lock overallAcceleration to ((ship:maxthrust/ship:mass) + (ship:maxthrust/(ship:mass - burnMass * 1)))/2.
lock distanceForBurn to ship:verticalSpeed * newBurnTime +  0.5 * (-9.81 + overallAcceleration/1000) * newBurnTime ^ 2.

wait until alt:radar + vehicleHeight <= (-distanceForBurn * 1).

lock throttle to 1.
lock steering to ship:SRFRETROGRADE.

until ship:verticalSpeed > -3 {
    clearscreen.
    print "DESCENT BURN".
    print overallAcceleration.
    print distanceForBurn.
}

lock steering to heading(90,90).

until alt:radar - vehicleHeight < 1 {
    set descentPid:MAXOUTPUT TO 1.0/ShipTWR().
    set descentPid:MINOUTPUT TO 0.7/ShipTWR().
    set descentPid:setpoint to -3.
    lock throttle to descentPid:update(time:seconds, ship:verticalSpeed).
}
lock throttle to 0.

set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.
wait 5.


