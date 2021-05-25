* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* 2021.05.25.


*Table B 4

*Estimates
/*
Lack of confidence in institutions	0.390***	0.244	0.458***	0.340**		0.188
									(0.079)		(0.334)	(0.126)		(0.125)		(0.135)
Observations						55			34		75			45			58
*/

local basemean=0.390
local basesd=0.079*55^0.5
local baseobs=55


local 2mean=0.244
local 2sd=0.334*34^0.5
local 2obs=34

ttesti `baseobs' `basemean' `basesd' `2obs' `2mean' `2sd'

local 2mean=0.188
local 2sd=0.135*58^0.5
local 2obs=58

ttesti `baseobs' `basemean' `basesd' `2obs' `2mean' `2sd'


*Table B 7
*2.049***	1.479**
*(0.423)	(0.540)


local basemean=0.828
local basesd=0.169*55^0.5
local baseobs=55


local 2mean=0.518
local 2sd=0.710*34^0.5
local 2obs=34

ttesti `baseobs' `basemean' `basesd' `2obs' `2mean' `2sd'