
set missionName to ship:name + "-mission-" + TIME:SECONDS + " " + RANDOM().

set logName to missionName + ".log".


set lastLog to 0.

function logTick{

    if time:seconds > lastLog + 1 {
        log
            time:seconds + ","          +
            ship:LATITUDE + ","         +
            ship:LONGITUDE + ","        +
            ship:AIRSPEED + ","         +
            ship:GROUNDSPEED + ","  +
            ship:VERTICALSPEED + ","    +
            ship:ALTITUDE + ","    +
            ship:MASS  + ","    +
            ship:DYNAMICPRESSURE  + ","    +
            ship:BEARING  + ","    +
            ship:HEADING
            to logName.
        set lastLog to TIME:SECONDS.
    }


}


function testing {
	print "HELLO WORLD!".
}

