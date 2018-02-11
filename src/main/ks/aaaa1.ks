run utils.


if ship:altitude < 1000 {

    wait 3.
    lock throttle to 1.
    lock steering to heading(90, 90).
    STAGE.

    set done to 0.

    when ship:altitude > 200 then {
        lock steering to heading(90, 45).
        STAGE.
    }

    when ship:altitude < 10000 and ship:airspeed > 800 then {
        lock throttle to 0.3.
    }

    when ship:altitude > 12000 then {
        lock steering to heading(90, 25).
        lock throttle to 1.
    }

    when ship:apoapsis > 75000 then {
        lock throttle to 0.
        lock steering to ship:prograde.
        when eta:apoapsis < 30 then {
            lock throttle to 1 - eta:apoapsis/30.
        }

    }

    when ship:periapsis > 73000 then {
        set done to 1.
    }
}




until done = 1 {
    logTick().
}