

until 1  = 0{


    set v to VECTOREXCLUDE(ship:prograde:starvector, ship:facing:forevector).
    set vDir to VDOT(v, prograde:topvector).
    //set v to vDir * v.

    //print VANG(v, ship:prograde:forevector).
//    if(VANG(v, ship:prograde:topvector) > 180){
//        set v to -v.
//    }

//    if(VDOT(v, ship:prograde:starvector) < 0){
//        set v to -v.
//    }


    set sign to vDir/abs(vDir).

    set myPitch to sign * VANG(ship:prograde:forevector, v).
//    set myPitch to VDOT(v, ship:facing:topvector) * VANG(ship:facing:topvector,v).
//    if((v - ship:prograde:topvector):MAG < (v - (-ship:prograde:topvector)):MAG){
//        set myPitch to -myPitch.
//    }


    print myPitch.

    clearvecdraws().

    doDraw(ship:prograde, "P", RGB(1,0,0)).
    doDraw(ship:facing,   "F", RGB(1,0,1)).
    doDrawVec(v, "V", RGB(0,1,0)).


    wait 0.2.

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