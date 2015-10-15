



until 1 = 0{
	print "Refueler Task Check".
    set fuelCargos to SHIP:PARTSTAGGED("fuelCargo").

    if(fuelCargos:length > 0){
    	run refueler_gather.
    }
    run solarpanels.


	wait 5.
}