



LIST PARTS in p.
SET txParts TO SHIP:PARTSTAGGED("tx").
print "Gathering Fuel...".
for x in txParts{
	print "CAN USE: " + x:NAME.
}
for x in p {
	if(x:TAG <> "tx" and isLiquidFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in txParts {
			set foo to TRANSFERALL("liquidfuel", x, t).
			set foo:active to true.
		}
	}
	if(x:TAG <> "tx" and isOxidizerFuelTank(x)){
		print "Transferring resources...: " + x:NAME.
		for t in txParts {
			set foo to TRANSFERALL("oxidizer", x, t).
			set foo:active to true.
		}
	}
}

for x in p {
    if(x:TAG <> "tx" and isLiquidFuelTank(x) and isOxidizerFuelTank(x)){
		for t in txParts {
			set foo to TRANSFER("liquidfuel", t, x, 50).
			set foo:active to true.
			set o to TRANSFER("oxidizer", t, x, 75).
			set o:active to true.
		}
		break.
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