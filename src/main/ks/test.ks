


//set rotateDraw to VECDRAWARGS( v(0,0,0), rotate * 5, RGB(0, 1, 0), "Target Rotation", 5, TRUE ).
//set aeonFacingDraw to VECDRAWARGS( v(0,0,0), aeon:facing:topvector * 5, RGB(0, 1, 0), "Target Facing", 5, TRUE ).
//set meFacingDraw to VECDRAWARGS( v(0,0,0), ship:facing:forevector * 5, RGB(0, 1, 0), "Me Facing", 5, TRUE ).
//



set ship:control:neutralize to true.
set lastRoll to 0.
set lastTime to TIME:SECONDS - 0.1.


until 1 = 0{
    set now to TIME:SECONDS.
    set elapsed to now - elapsed.


set ang to 90 - vang(ship:facing:topvector, ship:up:topvector).

set progradeDraw to VECDRAWARGS( v(0,0,0), ship:prograde:forevector * 5, RGB(0, 1, 0), "Prograde", 5, TRUE ).
//set facingDraw to VECDRAWARGS( v(0,0,0), ship:facing:forevector * 5, RGB(0, 1, 0), "Facing", 5, TRUE ).


set normVec to VCRS(SHIP:BODY:POSITION, SHIP:facing:forevector).
set vec to LOOKDIRUP(normVec, SHIP:BODY:POSITION).

set vec to ROTATEFROMTO(ship:facing:forevector, ship:prograde:forevector).




set vecThis to VANG(ship:up:forevector, ship:facing:topvector) .

set vec to ANGLEAXIS(-vec:roll, ship:facing:forevector) * vec.

set rotated to ANGLEAXIS(-vec:roll, ship:prograde:forevector) * ship:facing.

set proj to VECTOREXCLUDE(ship:prograde:topvector, ship:facing:starvector).
set angy to 90 - VANG(ship:facing:topvector, proj).

set please to ANGLEAXIS(angy, ship:prograde:topvector) * ship:facing.

set myPitch to 90 - VANG(ship:facing:topvector, VECTOREXCLUDE(ship:prograde:topvector, ship:facing:topvector)).
set myYaw   to 90 - VANG(ship:facing:starvector, VECTOREXCLUDE(ship:prograde:starvector, ship:facing:starvector)).
set myRoll  to angy.


set rollChange to (myRoll - lastRoll)/elapsed.
set maxSpeed to 10.
set desiredSpeed to min(maxSpeed,  abs(myRoll)/5) - rollChange/5.
set ship:control:roll to  (desiredSpeed - lastRoll)/maxSpeed.

//
//clearVecDraws().
//doDraw(ship:facing,   "F", RGB(1,1,0)).
//doDraw(ship:prograde, "P", RGB(1, 0, 1)).
//doDraw(please,        "Ans", RGB(1, 0, 0)).

//set ship:control:yaw to myYaw/10.
//set ship:control:pitch to -myPitch/45.

//doDrawVec(proj, "Projection", RGB(1,1,1)).
//doDraw(proj, "C", RGB(0.5,0.5,1)).
//lock steering to Q(1,1,0,0).

print "--".
print angy.
print myPitch.
print myYaw.
print "--".
print "ROTATE FROM TO roll      " + vec:roll.
print "ROTATE FROM TO pitch     " + vec:pitch.
print "ROTATE FROM TO roll      " + vec:yaw.
print "--".
print "ROTATED roll             " + rotated:roll.
print "ROTATED pitch            " + rotated:pitch.
print "ROTATED roll             " + rotated:yaw.
wait 0.1.


set lastRoll to myRoll.


}


function doDrawVec{
    parameter vec.
    parameter prefix.
    parameter color.

    VECDRAWARGS( v(4,0,0), vec*1, color, prefix, 5, TRUE ).
}

function doDraw{
    parameter matrix.
    parameter prefix.
    parameter color.

    VECDRAWARGS( v(4,0,0), matrix:forevector*1, color, prefix  + "f", 5, TRUE ).
    VECDRAWARGS( v(4,0,0), matrix:topvector, color, prefix + "t", 5, TRUE ).
    VECDRAWARGS( v(4,0,0), matrix:starvector, color, prefix + "s", 5, TRUE ).
}