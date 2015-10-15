

LIST PARTS in p.
print "Running fuel transfer machine...".
set didIt to 0.
for x in p {
	set i to 0.
	if(isLiquidFuelTank(x) or isOxidizerTank(x)){
		for y in p {
			if(i > didIt){
				if(isLiquidFuelTank(y)){
					set foo to TRANSFERALL("liquidfuel", y, x).
					set foo:active to true.
					//set foo to TRANSFERALL("oxidizer", y, x).
					//set foo:active to true.
				}
				if(isOxidizerTank(y) and isOxidizerTank(x)){
					set foo to TRANSFERALL("oxidizer", y, x).
					set foo:active to true.
				}
			}
			set i to i + 1.
		}
	}
	set didIt to didIt + 1.
}

print "done...".

function isLiquidFuelTank{
	parameter part.
	return part:NAME = "adapterMk3-Size2" or
		   part:NAME = "fuelTank.long" or
		   part:NAME = "mk3FuselageLF.100" or
		   part:NAME = "mk3FuselageLFO.25" or
		   part:NAME = "mk3FuselageLFO.50".
}

function isOxidizerTank{
	parameter part.
	return part:NAME = "adapterMk3-Size2" or
		   part:NAME = "fuelTank.long" or
		   part:NAME = "mk3FuselageLFO.25" or
		   part:NAME = "mk3FuselageLFO.50".
}