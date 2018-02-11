
wait 1.

set throttle to 0.
lock throttle to 1.
lock steering to heading(90,90).

when ship:apoapsis > 2000 then {
    lock throttle to 0.
    when ship:verticalSpeed < -3 then {
        set landing to 1.

    }
}

wait 1.
stage.

until ship:verticalSpeed < -3 {}


log