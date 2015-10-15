

LIST PARTS in p.


for x in p {
    if(x:NAME = "solarPanels1"){
        set mod to x:GETMODULE("ModuleDeployableSolarPanel").
        if(SHIP:ALTITUDE > 70000 and mod:GETFIELD("status") = "Retracted"){
            mod:DOEVENT("extend panels").
        }
        if(SHIP:ALTITUDE < 70000 and mod:GETFIELD("status") = "Deployed"){
            mod:DOEVENT("retract panels").
        }
    }
}