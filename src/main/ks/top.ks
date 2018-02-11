


set desiredApoapsis to 60000.
set deployAltitude to desiredApoapsis * 0.8.


wait until ship:altitude > deployAltitude.

wait 5.

lock throttle to 1.
lock steering to heading(90,70).


