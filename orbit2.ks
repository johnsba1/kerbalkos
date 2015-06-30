
set startTurnAltitude to 0.
set endTurnAltitude to 0.

set startSpeedAltitude to 0.
set endSpeedAltitude to 10000.

set startSpeed to 1.
  
set speedMultipler to 1.5.
set currentAngle to 90.
set requestedAngle to 90.
set speed to 100.
set requestedThrottle to 1.
set lastSpeed to 0.

set lastMaxThrust to 0.

set TIME_START to TIME:SECONDS.

set TURN_SPEED to 5.
set TIMESTEP to 0.25.

set atmosphereHeight to 70000.

set phaseOne to 1.
set PHASE_ONE_APOAPSIS_STOP to atmosphereHeight + 10000.
set PHASE_ONE_TURN_ALTITUDE to atmosphereHeight * (1/7).
set PHASE_ONE_TURN_MIN_ANGLE to 45.

set PHASE_ONE_TURN_SECOND_ANGLE to 15.
set PHASE_ONE_TURN_SECOND_ANGLE_ALTITUDE to atmosphereHeight * (5/7).
set PHASE_ONE_TURN_SECOND_ANGLE_ENABLED to 1.

set PHASE_ONE_TV_COEFFICIENT to 0.7.

set phaseTwo to 0.
set PHASE_TWO_ALTITUDE_START to 1000.
set PHASE_TWO_PEROAPSIS_STOP to atmosphereHeight + 1000.

set currentAngle to 90.

set done to 0.

info("Starting phase 1...").
UNTIL phaseOne = 0{   
    tryNextStage().
    if SHIP:ALTITUDE > PHASE_ONE_TURN_ALTITUDE AND currentAngle >= PHASE_ONE_TURN_MIN_ANGLE  {
      set currentAngle to currentAngle - TIMESTEP * TURN_SPEED.
    }
    if PHASE_ONE_TURN_SECOND_ANGLE_ENABLED = 1 AND SHIP:APOAPSIS > PHASE_ONE_TURN_SECOND_ANGLE_ALTITUDE AND currentAngle >= PHASE_ONE_TURN_SECOND_ANGLE  {
      set currentAngle to currentAngle - TIMESTEP * TURN_SPEED.
    }
    
    set speed to termVel().
    set twr to ShipTWR().
    IF twr > 0 {
      set requestedThrottle to 1/twr  +(speed - SHIP:AIRSPEED)/20. 
    }
    
    IF requestedThrottle > 1 {
      set requestedThrottle to 1.
    }
    IF requestedThrottle < 0 {
      set requestedThrottle to 0.
    }
    
    LOCK THROTTLE TO requestedThrottle.    
    LOCK STEERING TO HEADING(90,currentAngle). // east, 45 degrees pitch.    

    set lastSpeed to SHIP:AIRSPEED.
    set lastMaxThrust to SHIP:MAXTHRUST.
    WAIT TIMESTEP.
    if SHIP:APOAPSIS > PHASE_ONE_APOAPSIS_STOP  {
      set phaseOne to 0.
    }
}
LOCK THROTTLE TO 0.

info("Phase 1 completed. Apoapsis reached.").
info("Waiting for phase 2 to start").
LOCK STEERING TO HEADING(90,0).
UNTIL phaseTwo = 1 { 
  if SHIP:ALTITUDE > SHIP:APOAPSIS - PHASE_TWO_ALTITUDE_START  {  
    set phaseTwo to 1.
  }  
  WAIT TIMESTEP.
}
info("Starting phase 2...").
set phaseTwo to 1.
LOCK THROTTLE TO 1.  
UNTIL phaseTwo = 0 {   
    
    if SHIP:PERIAPSIS > 71000 {
      set phaseTwo to 0.
      LOCK THROTTLE TO 0.
    }
    
    if SHIP:ALTITUDE > SHIP:APOAPSIS - PHASE_TWO_ALTITUDE_START  {        
      LOCK THROTTLE TO 1.  
    } 
    else {
      LOCK THROTTLE TO 0.
    }
    tryNextStage().
    WAIT TIMESTEP.
}

info("Phase 2 completed.").
info("Should now be in orbit").
LOCK THROTTLE TO 0.



declare function termVel { 
    set scaleHeight to 5000.
    set atmosphericPressure to (CONSTANT():E ^ (-SHIP:ALTITUDE/scaleHeight)). 
    set atmosphericDensity to 1.2230948554874 * atmosphericPressure.
    set crossSectionalArea to 0.008 * SHIP:MASS.
    set dragForce to 0.5 * atmosphericDensity * SHIP:AIRSPEED^2 * 0.2 * crossSectionalArea.
    
    set gravConstant to 6.674 * 10^(-11). 
    set kerbalPlanetaryMass to 5.2915793 * 10^22.
    set kerbalRadius to 600000.  
    set altitudeFromCenter to 600000 + SHIP:ALTITUDE.
    set terminalVelocity to sqrt((1250 * gravConstant * kerbalPlanetaryMass)/(altitudeFromCenter^2 * atmosphericDensity )).    
    
    return terminalVelocity * PHASE_ONE_TV_COEFFICIENT.
}


declare function tryNextStage {
  for r in SHIP:PARTS {
    if isDecoupler(r) {
      local fuel to getFuelUnderCoupler(r).
      if fuel = 0{
        info("Decoupling: " + r:NAME).
        parachute(r).
        decouple(r).
      }        
    }
  }
}

function getFuelUnderCoupler{
  parameter part.  
  local fuel to part:MASS - part:DRYMASS.
  for l in part:CHILDREN {
    local f to getFuelUnderCoupler(l).
    set fuel to fuel + f.
  }  
  return fuel.
}

function parachute{
  parameter part.
  for m in part:MODULES{
    if m = "ModuleParachute"{
      if part:GETMODULE("ModuleParachute"):HASACTION("deploy") {
        part:GETMODULE("ModuleParachute"):DOEVENT("deploy chute").
      }
    }
  }
  for l in part:CHILDREN {
    parachute(l).
  }    
}

function decouple{
  parameter part.    
  for m in part:MODULES{
    local module to part:GETMODULE(m).
    if module:HASACTION("decouple"){
      module:DOEVENT("decouple").
      return 0.
    } 
  }
}


declare function ShipTWR
{
  set mth to SHIP:MAXTHRUST. // (depends on fixed kOS issue 940)
  set r to SHIP:ALTITUDE+SHIP:BODY:RADIUS.
  set w to SHIP:MASS * SHIP:BODY:MU / r / r.
  return mth/w.
}

function info {
  parameter message.
  print FLOOR(TIME:SECONDS - TIME_START) + ":   " + message.
}

function isDecoupler{
  parameter part.  
  return part:NAME = "radialDecoupler" OR 
         part:NAME = "radialDecoupler1-2" OR 
         part:NAME = "radialDecoupler2" OR 
         part:NAME = "stackDecoupler".
}





