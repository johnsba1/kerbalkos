

LIST PARTS in p.
SET txParts TO SHIP:PARTSTAGGED("tx").
SET fuelCargos TO SHIP:PARTSTAGGED("fuelCargo").
print "Gathering Fuel...".
for x in fuelCargos {
	if(isLiquidFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in txParts {
			set foo to TRANSFERALL("liquidfuel", x, t).
			set foo:active to true.
		}
	}
	if(isOxidizerFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in txParts {
			set foo to TRANSFERALL("oxidizer", x, t).
			set foo:active to true.
		}
	}
}

function isLiquidFuelTank{
	parameter part.
	return part:NAME = "adapterMk3-Size2" or
		   part:NAME = "mk3FuselageLF.100" or
		   part:NAME = "mk3FuselageLFO.25" or
		   part:NAME = "mk3FuselageLFO.50".
}

function isOxidizerFuelTank{
	parameter part.
	return part:NAME = "adapterMk3-Size2" or
		   part:NAME = "mk3FuselageLFO.25" or
		   part:NAME = "mk3FuselageLFO.50".
}