


SET aeon TO VESSEL("Aeon 3").

SET SHIP:CONTROL:NEUTRALIZE to True.


until 1 = 0 {


	lock steering to -aeon:facing:topvector.
	wait 0.3.

}