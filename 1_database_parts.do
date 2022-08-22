cap log close
log using "$logs\1_database_parts.smcl", replace

* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi, Ágnes Szabó-Morvai
* Last updated on 18 July 2022 

*Data on excess mortality in 2020
import delimited "$newdata\excess_mortality\excess_mortality.csv" , clear
order location date time_unit
sort location date
rename location country
merge m:1 country using "$data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge
drop if p_scores_all_ages==.
sort country date
tab date if time_uni=="monthly"
tab date if time_uni=="weekly"
gen year=substr(date,1,4)
tab year
gen month=substr(date,6,2)
tab month
keep if year=="2020"
collapse p_scores_all_ages, by(country)
save "$data\excess_deaths.dta", replace

*BMI
import delimited "$source\Mean BMI - NCD RisC (2017)\Mean BMI - NCD RisC (2017).csv", clear
rename entity country
do "$do\1b_replace.do"
keep if year==2016
egen bmi=rowmean(meanbmimale meanbmifemale) // avg BMI of both genders together
keep country bmi
save "$data\bmi.dta", replace

*share of death by risk factors (including alcohol)
import delimited "$source\Share of deaths by risk factor (IHME, 2019)\Share of deaths by risk factor (IHME, 2019).csv", clear
rename entity country
do "$do\1b_replace.do"
gsort country -year
*keep the latest data
duplicates drop country, force
keep dietaryrisksihme2019 obesityihme2019 lowphysicalactivityihme2019 smokingihme2019 ///
alcoholuseihme2019	 highbloodsugarihme2019	highcholesterolihme2019	highbloodpressureihme2019 impairedkidneyfunctionihme2019 airpollutiontotalihme2019	country
save "$data\death_risk.dta", replace

* days since first covid case until 21 March 2021
import excel "$data\OWID\owid-covid-data.xlsx", sheet("Sheet1") firstrow clear
rename date strdate
keep if total_deaths>=1 & total_deaths!=.
gen year = substr(strdate,1,4)
gen month = substr(strdate,6,2)
gen day = substr(strdate,9,2)
destring year, replace
destring month, replace
destring day, replace
gen date = mdy(month,day,year)
egen covstart = min(date), by(location)
keep if date == covstart
drop date year month day strdate
gen today = mdy(03,21,2021)
gen daysincovid = today - covstart
lab var daysincovid "No. of days since the first death"
rename location country
do "$do\1b_replace.do"
keep country daysincovid
save "$data\daysincovid.dta", replace

* Google trends mobility
set trace off
import delimited "$google\2020_AE_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
save "$data\mobility.dta", replace
sleep 1000
foreach c in AF	AG	AO	AR	AT	AU	AW	BA	BB	BD	BE	BF	BG	BH	BJ	BO	BR	BS	BW	BY	BZ	CA	CH	CI	CL	CM	CO	CR	CV	CZ	DE	DK	DO	EC	EE	EG	ES	FI	FJ	FR	GA	GB	GE	GH	GR	GT	GW	HK	HN	HR		 {
disp "`c'"	
import delimited "$google\2020_`c'_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
append using "$data\mobility.dta", force
save "$data\mobility.dta", replace 
sleep 1000
clear	
}
foreach c in HT	HU	ID	IE	IL	IN	IQ	IT	JM	JO	JP	KE	KG	KH	KR	KW	KZ	LA	LB	 {
disp "`c'"	
import delimited "$google\2020_`c'_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
append using "$data\mobility.dta", force
save "$data\mobility.dta", replace 
sleep 1000
clear	
}
foreach c in LI	LK	LT	LU	LV	LY	MA	MD	MK	ML	MM	MN	MT	MU	MX	MY	 {
disp "`c'"	
import delimited "$google\2020_`c'_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
append using "$data\mobility.dta", force
save "$data\mobility.dta", replace 
sleep 1000
clear	
}
foreach c in MZ	NA	NE	NG	NI	NL	NO	NP	NZ	OM	PA	PE	PG	PH	PK	PL	PR	PT	PY	QA	{
disp "`c'"	
import delimited "$google\2020_`c'_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
append using "$data\mobility.dta", force
save "$data\mobility.dta", replace 
sleep 1000
clear	
}
foreach c in RE	RO	RS	RU	RW	SA	SE	SG	SI	SK	SN	SV	TG	TH	TJ	TR	TT	TW	TZ	UA	UG	US	UY	VE	VN	YE	ZA	ZM	ZW {
disp "`c'"	
import delimited "$google\2020_`c'_Region_Mobility_Report.csv", clear
keep country_region_code country_region retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b 
gcollapse retail_and_recreation_percent_ch grocery_and_pharmacy_percent_cha transit_stations_percent_change_ workplaces_percent_change_from_b  , by(country_region_code country_region )
append using "$data\mobility.dta", force
save "$data\mobility.dta", replace 
sleep 1000
clear	
}
use "$data\mobility.dta", clear
rename country_region country
do "$do\1b_replace.do"
save "$data\mobility.dta", replace 


* Health expenditure
import delimited "$source\Health expenditure per capita - World Bank WDI (2018)\Health expenditure per capita - World Bank WDI (2018).csv", clear
rename entity country
do "$do\1b_replace.do"
save "$data\health_exp.dta", replace 

*No. of deaths before the pandemic
import delimited "$covid\number-of-deaths-by-age-group.csv", delimiter(comma) clear
rename entity country
do "$do\1b_replace.do"
gsort country -year
duplicates drop country, force
gen total_mortality=deathsallcausessexbothageunder5n+deathsallcausessexbothage70years+deathsallcausessexbothage5069yea+deathsallcausessexbothage514year+deathsallcausessexbothage1549yea
keep country total_mortality
save "$data\mortality.dta", replace 

*Data on tightness - following the rules https://www.thelancet.com/action/showPdf?pii=S2542-5196%2820%2930301-6
import delimited "$covid\Data_on_tightness.csv", delimiter(comma) clear
keep country tightness
do "$do\1b_replace.do"
save "$data\tightness.dta", replace

*confidence in government and trust pca
use "$wvs\ZA7505_v1-1-0.dta" , clear
decode cntry, gen(country)
local list E069_04 E069_06 E069_07 E069_11 E069_12 E069_17 D001_B G007_18_B G007_33_B G007_34_B G007_35_B G007_36_B  A042
foreach item in `list' {
replace `item'=. if `item'<0
gen `item'_missing=0
replace `item'_missing=1 if `item'==.
}
local list D001_B G007_18_B G007_33_B G007_34_B G007_35_B G007_36_B
foreach item in `list' {
sum `item'
replace `item' = (`item'-r(mean))/r(sd)
}
pca D001_B G007_18_B G007_33_B G007_34_B G007_35_B G007_36_B
predict trust_pca
replace trust_pca=-1*trust_pca
sum trust_pca

*what share of interviews was conducted after 01/03/2020?
gen interview_share=0
replace interview_share=1 if ivdate>20200301 & ivdate>20200301!=.

*If there are two dates capturing the end of fieldwork, we will keep the latest
sort country
by country: egen fw_max=max(fw_end)
replace fw_end=fw_max
local list E069_04* E069_06* E069_07* E069_11* E069_12* E069_17* trust_pca fw_end interview_share
collapse (mean) `list' [w= gwght], by(cntry_AN country)
rename E069_04 confidence_in_press
rename E069_06 confidence_in_police
rename E069_07 confidence_in_parliament
rename E069_11 confidence_in_government
rename E069_12 confidence_in_parties
rename E069_17 confidence_in_justice

*share of missings
rename E069_04_missing confidence_in_press_missing
rename E069_06_missing confidence_in_police_missing
rename E069_07_missing confidence_in_parliament_missing
rename E069_11_missing confidence_in_government_missing
rename E069_12_missing confidence_in_parties_missing
rename E069_17_missing confidence_in_justice_missing
do "$do\1b_replace.do"
merge m:1 country using "$data\75_countries.dta"
keep if _merge==3
drop _merge
save "$data\confidence_in_government.dta", replace 

*Gini coeff
*https://datacatalog.worldbank.org/gini-index-world-bank-estimate-2 
import delimited "$source\Gini Index – World Bank (2016)\Gini Index – World Bank (2016).csv", delimiter(comma) clear
rename entity country
do "$do\1b_replace.do"
gsort country -year
duplicates drop country, force
save "$data\gini.dta", replace 

*World Governance Indicators 
*https://info.worldbank.org/governance/wgi/Home/Documents
use "$covid\wgidataset_stata\wgidataset.dta" , clear
rename gee gov_effectiveness
lab var gov_effectiveness "Government effectiveness, WGI"
rename countryname country
do "$do\1b_replace.do"
gsort country -year
duplicates drop country, force
keep country gov_effectiveness 
save "$data\wgi.dta", replace 

*Freedom House democracy data
*https://freedomhouse.org/countries/freedom-world/scores , copy-paste on 13/04/2021
import excel "$covid\FH_democracy_data.xlsx", sheet("Munka1") firstrow clear
do "$do\1b_replace.do"
save "$data\FH_democracy.dta", replace 

*ALternative observation periods until 31 March 2021
import excel "$data\OWID\owid-covid-data.xlsx",  firstrow clear

sort iso_code date
rename location country
sort country date
keep country total_deaths_per_million date


merge m:1 country using "$data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge

keep country total_deaths_per_million date
gen Alndeath=ln(total_deaths_per_million)
sort country date

keep if date=="2021-03-21" | date=="2021-02-21" | date=="2021-01-21" | date=="2020-12-21" | date=="2020-11-21" | date=="2020-10-21" 

sort country date
by country: gen sor=_n
keep  Alndeath country sor
reshape wide Alndeath, i(country) j(sor)
save "$data\alt_observation_periods_1.dta", replace 

*ALternative observation periods between 21 Apr 2021 and 21 Dec 2021
import delimited "$newdata\owid-covid-data.csv", clear 

sort iso_code date
rename location country
merge m:1 country using "$data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge

keep country total_deaths_per_million date
gen Alndeath=ln(total_deaths_per_million)

sort country date
*by country date: replace Alndeath=Alndeath[_n-1] if Alndeath==.

keep if date=="2021-12-21" | date=="2021-11-21" | date=="2021-10-21" | ///
date=="2021-09-21" | date=="2021-08-21" | date=="2021-07-21" | date=="2021-06-21" | date=="2021-05-21" | date=="2021-04-21" 

sort country date
by country: gen sor=_n
replace sor=sor+6
keep  Alndeath country sor
reshape wide Alndeath, i(country) j(sor)
merge 1:1 country using "$data\alt_observation_periods_1.dta"
drop _merge
save "$data\alt_observation_periods.dta", replace 


********************Corruption*********************
*https://www.transparency.org/en/cpi/2020/index/nzl
import excel "$covid\corruption_data\corruption_data_toStata.xlsx", sheet("CPI Timeseries 2012 - 2020") firstrow clear
do "$do\1b_replace.do"
save "$data\corruption.dta", replace

***Migrant stock
*https://data.worldbank.org/indicator/SM.POP.TOTL.ZS?view=chart 
import excel "$covid\WB_migrant_stock_2015",  firstrow clear
do "$do\1b_replace.do"
save "$data\migrant_stock.dta", replace

*****************************
*No. of medical doctors******
*******************
import delimited "$covid\WHO_No_of_medical_doctors.csv", varnames(1) encoding(UTF-8) clear
rename value no_of_medical_doctors
rename location country
keep no_of_medical_doctors country
do "$do\1b_replace.do"
save "$data\no_of_medical_doctors.dta", replace


*Cancer survival rate
import delimited "$source\Five year cancer survival rates - Allemani et al\Five year cancer survival rates - Allemani et al. .csv", delimiter(comma) clear
rename entity country
do "$do\1b_replace.do"
gsort country -year
duplicates drop country, force
drop year
save "$data\cancer_survival.dta", replace


*prison population rate data
*https://www.prisonstudies.org/highest-to-lowest/prison_population_rate?field_region_taxonomy_tid=All
import excel "$covid\prison_population_data",  firstrow clear
do "$do\1b_replace.do"
rename PrisonPopulationRate prison_rate
save "$data\prison_data.dta", replace

*How comparable Covid death data are?
*https://analysis.covid19healthsystem.org/index.php/2020/06/04/how-comparable-is-covid-19-mortality-across-countries/
import excel "$covid\Death_definition_toStata.xlsx", sheet("Munka1") firstrow clear
cap drop D E F
rename death death_register
lab var death_register "Policy to register deaths attributed to COVID-19"
lab def ldeath_register ///
1 "Clinical diagnosis-based (WHO definition)"  ///
2 "Test-based" ///
3 "Both"
lab val death_register ldeath_register
do "$do\1b_replace.do"
save "$data\deaths_resiter_policy.dta", replace

*list of OECD countries
import excel "$covid\oecd_countries.xlsx", sheet("Munka1") firstrow clear
do "$do\1b_replace.do"
save "$data\oecd.dta", replace

*oxford tracker direct data
*https://github.com/OxCGRT/covid-policy-tracker/blob/master/documentation/codebook.md
import delimited "$covid\OxCGRT_latest.txt" , clear
rename countryname country
do "$do\1b_replace.do"
drop if date>20210321
merge m:1 country using "$covid\ourworldindata data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge
*individual implementation-reliant measures: (= 1 if C4 == 3 | C4 ==4 |  C4 ==2 |  C4 ==3 )
gen implement=0
replace implement=1 if  c4_restrictionsongatherings==3 |  c4_restrictionsongatherings==4
gen contact_tracing=0
replace contact_tracing=1 if h3_contacttracing==2

*closing schools and restricting gatherings
gen closing=c1_schoolclosing+c2_workplaceclosing+c3_cancelpublicevents+c4_restrictionsongatherings+c6_stayathomerequirements 
lab var closing "Social distancing measures in place"
collapse implement contact_tracing closing, by(country date)
save "$data\OxCGRT_latest.data", replace
collapse (mean) mean_implement=implement mean_contact=contact_tracing, by(country)
lab var mean_implement "Stringency submeasure, restrictions on personal gatherings (continuous)"
lab var mean_contact "Stringency submeasure, comprehensice contract tracing (continuous)"
save "$data\stringency_implementation.dta" , replace

*Educational Attainment
import delimited "$source\Educational Attainment - Barro Lee Education Dataset (2010)\Educational Attainment - Barro Lee Education Dataset (2010) .csv", clear
keep if year==2010
rename entity country
do "$do\1b_replace.do"
rename educationalattainmentaverageyear yearsofedu
save "$data\education.dta", replace

*PISA scores
import delimited "$source\OECD Education! PISA Test Scores - PISA (2015)\OECD Education! PISA Test Scores - PISA (2015).csv", clear
keep if year==2012
rename oecdpisaeducationscorepisa2015 pisa
rename oecdpisareadingscore20002012pisa pisa_reading
lab var pisa "Pisa education scores"
lab var pisa_reading "Pisa reading score"
rename entity country
do "$do\1b_replace.do"
save "$data\pisa.dta", replace

*Timing of measures: time until increasing stringency in wave 1 and wave 2
import excel "$data\OWID\owid-covid-data.xlsx", sheet("Sheet1") firstrow clear
rename location country
rename date strdate
gen year = substr(strdate,1,4)
gen month = substr(strdate,6,2)
gen day = substr(strdate,9,2)
gen date=year+month+day
destring date, replace
cap drop _merge
merge 1:1 country date using "$data\OxCGRT_latest.data"
drop _merge
destring year, replace
destring month, replace
destring day, replace
cap drop date
gen date = mdy(month,day,year)
merge m:1 country using "$covid\ourworldindata data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge
drop if closing==.
drop if date==.
sort country
by country: egen max_closing=max(closing)
by country: egen mean_closing=mean(closing)
by country: egen sd_closing=sd(closing)
keep country max_closing mean_closing sd_closing
duplicates drop
do "$do\1b_replace.do"
save "$data\closure.dta", replace

******Falk et al economic preferences******
*https://www.briq-institute.org/global-preferences/downloads?submitted=1
use "$covid\ourworldindata data\Falk et al economic preferences\country.dta" , clear
do "$do\1b_replace.do"
save "$data\falk_et_al.dta", replace

***Voter turnout***
*data source: https://www.idea.int/data-tools/world-view/40
import excel "$covid\voter_turnout.xls", sheet("Worksheet") firstrow clear
keep if Electiontype=="Parliamentary"
rename Country country
do "$do\1b_replace.do"
merge m:1 country using "$covid\ourworldindata data\75_countries.dta"
sort _merge country
keep if _merge==3
drop if Year>=2020
drop if VoterTurnout==""
gsort +country -Year
duplicates drop country, force
gen voterturnout=substr(VoterTurnout,1,5)
order VoterTurnout voterturnout
destring voterturnout, replace
keep country voterturnout
save "$data\voterturnout.dta", replace

***Vaccinations****
import delimited "$newdata\vaccinations\vaccinations.csv", clear
order location date 
sort location date
rename location country
merge m:1 country using "$data\75_countries.dta"
sort _merge country
keep if _merge==3
drop _merge

rename people_fully_vaccinated_per_hund vaccination_rate

order country date vaccination_rate
sort country date

local list vaccination_rate
foreach item in `list' {
by country: replace `item'=`item'[_n-1] if `item'==.
}

sum vaccination_rate if date=="2022-01-01"
edit if vaccination_rate==. & date=="2022-01-01"
edit if country=="Ethiopia"

sort country date
local list vaccination_rate
sum vaccination_rate if country=="Ethiopia" & date=="2022-03-06"
replace vaccination_rate=r(mean) if country=="Ethiopia" & date=="2022-01-01"

keep if date=="2022-01-01"
keep country vaccination_rate
sum vaccination_rate
save "$data\vaccination.dta", replace

cap log close