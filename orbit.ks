
set startTurnAltitude to 0.
set endTurnAltitude to 0.

set startSpeedAltitude to 0.
set endSpeedAltitude to 10000.

set startSpeed to 100.
set endSpeed to 300.
  
set speedMultipler to 1.5.
set currentAngle to 90.
set requestedAngle to 90.
set speed to 100 * speedMultipler.
set requestedThrottle to 1.
set acceleration to 0.
set lastSpeed to 0.
set jerk to 0.

set lastMaxThrust to 0.

set done to 0.

set turnspeed to 2.
set timestep to 0.25.

set lastThrottle to 0.

LOCK STEERING TO UP.

PRINT "Main throttle up.  2 seconds to stabalize it.".
LOCK THROTTLE TO 1.0.   // 1.0 is the max, 0.0 is idle.

WHEN SHIP:ALTITUDE > 3000 THEN {
  set speed to 130 * speedMultipler.
}
WHEN SHIP:ALTITUDE > 5000 THEN {
  set speed to 160 * speedMultipler.
  set requestedAngle TO 10.
}

WHEN SHIP:ALTITUDE > 8000 THEN {
  set speed to 210 * speedMultipler.
  set requestedAngle TO 30.
}

WHEN SHIP:ALTITUDE > 10000 THEN {
  set speed to 240 * speedMultipler.
  set requestedAngle TO 45.
}
WHEN SHIP:ALTITUDE > 12000 THEN {
  set speed to 350 * speedMultipler.
}

WHEN SHIP:ALTITUDE > 15000 THEN {
  set speed to 425 * speedMultipler.
}
WHEN SHIP:ALTITUDE > 20000 THEN {
  set speed to 500 * speedMultipler.
}
WHEN SHIP:ALTITUDE > 25000 THEN {
  set speed to 2000 * speedMultipler.
}

WHEN SHIP:APOAPSIS > 71000 THEN {
  set speed to 0.
}
WHEN SHIP:ALTITUDE > 60000 THEN {
    set requestedAngle TO 0.
}
WHEN SHIP:ALTITUDE > 67000 THEN {
    set speed to 2700.
}

WHEN SHIP:PERIAPSIS > 71000 THEN {
  set done to 1.
}

WHEN STAGE:LIQUIDFUEL < 0.001 THEN {
    PRINT "No liquidfuel.  Attempting to stage.".
    STAGE.
    PRESERVE.
}

UNTIL done = 1{
    CLEARSCREEN.
    
    IF lastMaxThrust > SHIP:MAXTHRUST{
      STAGE.
    }
    
    set jerk to SHIP:VERTICALSPEED - lastSpeed - acceleration.
    set acceleration to SHIP:VERTICALSPEED - lastSpeed.
    IF requestedAngle < currentAngle {
      set currentAngle to currentAngle - 1 * timestep * turnspeed.
    }
    IF requestedAngle > currentAngle {
      set currentAngle to currentAngle + 1 * timestep * turnspeed.
    }
    set twr to SHIP:MAXTHRUST/(SHIP:MASS * 9.81).
    IF twr > 0 {
    set requestedThrottle to 1/twr  +(speed - SHIP:VERTICALSPEED)/20. 
    }
    
    IF requestedThrottle > 1 {
      set requestedThrottle to 1.
    }
    IF requestedThrottle < 0 {
      set requestedThrottle to 0.
    }
    
    LOCK THROTTLE TO requestedThrottle.
    PRINT "===== SYSTEM STATUS =====".
    PRINT "   DESIRED ANGLE:    " + requestedAngle.
    PRINT "   THROTTLE:         " + requestedThrottle.
    PRINT "   DESIRED SPEED:    " + speed.
    PRINT "   DESIRED SPEED:    " + speed.
    
    PRINT "===== SHIP =====".
    PRINT "   ANGLE:        " + currentAngle.
    PRINT "   SPEED:        " + SHIP:VERTICALSPEED.
    PRINT "   ACCELERATION: " + acceleration.
    PRINT "   JERK:         " + jerk.
    PRINT "   MAX THRUST:   " + SHIP:MAXTHRUST.
    PRINT "   MASS:         " + SHIP:MASS.
    PRINT "   MAX TWR:      " + SHIP:MAXTHRUST/SHIP:MASS.
    
    LIST engines in SHIP:ENGINES
    
    FOR resource in STAGE:RESOURCES {
      PRINT resource.
    }
    FOR part in SHIP:PARTS {
    }
    
    
    
    
    LOCK STEERING TO HEADING(90,currentAngle). // east, 45 degrees pitch.    

    set lastSpeed to SHIP:VERTICALSPEED.
    set lastMaxThrust to SHIP:MAXTHRUST.
    WAIT timestep.
}

PRINT "IN ORBIT".




