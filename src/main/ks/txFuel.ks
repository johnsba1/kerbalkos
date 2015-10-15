parameter fromTag.
parameter toTag.



LIST PARTS in p.
SET fromParts to SHIP:PARTSTAGGED(fromTag).
SET toParts TO SHIP:PARTSTAGGED(toTag).
print "Transferring Fuel...".
for x in toParts{
	print "Transfering tot: " + x:NAME.
}
for x in fromParts {
	if(isLiquidFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in toParts {
			set foo to TRANSFERALL("liquidfuel", x, t).
			set foo:active to true.
		}
	}
	if(isOxidizerFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in toParts {
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
		   part:NAME = "fuelTank3-2" or
		   part:NAME = "mk3FuselageLFO.50".
}

function isOxidizerFuelTank{
	parameter part.
	return part:NAME = "adapterMk3-Size2" or
		   part:NAME = "mk3FuselageLFO.25" or
		   part:NAME = "fuelTank3-2" or
		   part:NAME = "mk3FuselageLFO.50".
}