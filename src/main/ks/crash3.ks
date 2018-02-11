
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


declare function getBurnDistanceForSpeed{
    declare parameter desiredSpeed.

    set isp to 0.
    LIST ENGINES IN allEngines.
    FOR eng IN allEngines {
        set isp to eng:SEALEVELISP.
    }.
    set T to ship:maxthrust.
    set ve to isp * 9.81.
    set mdot to T / (isp * 9.81).
    set newBurnTime to (ship:mass * ve / T) * (1 - CONSTANT:E^(ship:verticalSpeed/ve)).
    set burnMass to mdot * newBurnTime.
    set overallAcceleration to ((ship:maxthrust/ship:mass) + (ship:maxthrust/(ship:mass - burnMass * 1)))/2.
    set distanceForBurn to (ship:verticalSpeed + desiredSpeed) * newBurnTime +  0.5 * (overallAcceleration/1000) * newBurnTime ^ 2.

    return distanceForBurn.
}

set descentPid to PIDLOOP(.1,.5,.01, 0, 1).
set landing to 0.
set stopping to 0.
set finalTouchdown to 0.
set landingHeight to 84.
set vehicleHeight to alt:radar.
set desiredParachuteSpeed to 250.
set desiredApoapsis to 60000.
set deployAltitude to desiredApoapsis * 0.8.


wait 1.
set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.

lock throttle to 1.
lock steering to heading(90,89).

stage.


wait until ship:apoapsis > desiredApoapsis.

lock throttle to 0.
lock steering to heading(90,90).

wait until ship:altitude > deployAltitude.

print "Staging...".
stage.


wait until ship:verticalSpeed < -3.

print "Waiting for sufficient pressure to deploy chutes".

wait until alt:radar < 3000.


print "Burning until safe for parachutes...".
lock throttle to 1.
lock steering to ship:SRFRETROGRADE.

wait until ship:verticalSpeed > -250.


print "Deploying chutes".
lock throttle to 0.
stage.
stage.

wait until alt:radar < 300.

print "Slowing down for landing".
lock throttle to 1.
lock steering to ship:SRFRETROGRADE.

wait until ship:verticalSpeed > -20.

lock throttle to 0.
lock steering to heading(90,90).

wait until alt:radar < 150.

print "Final touchdown...".
until alt:radar - vehicleHeight < 1 {
    set descentPid:MAXOUTPUT TO 1.
    set descentPid:MINOUTPUT TO 0.
    set descentPid:setpoint to -3.
    lock throttle to descentPid:update(time:seconds, ship:verticalSpeed).
}
lock throttle to 0.

set SHIP:CONTROL:PILOTMAINTHROTTLE to 0.
wait 5.


