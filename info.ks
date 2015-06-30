set PHASE_ONE_TV_COEFFICIENT to 1.
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

set working to 1.

until working = 0 {
  
  print SHIP:ALTITUDE + " " + termVel().
  wait 1.

}