* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* 2021.05.25.

use "$data\OWID\owid-covid-data.dta", clear
sort iso_code date
*dropping continents
drop if continent==""
drop if total_deaths_per_million==.
local list total_cases_per_million total_deaths_per_million stringency_index total_tests_per_thousand population population_density aged_65_older gdp_per_capita hospital_beds_per_thousand life_expectancy
foreach item in `list' {
by iso_code: replace `item'=`item'[_n-1] if `item'==.
}
*max and mean stringency
by iso_code: egen max_stringency=max(stringency_index)
by iso_code: egen mean_stringency=mean(stringency_index)
*mean positive rate
by iso_code: egen mean_positive_rate=mean(positive_rate )
replace stringency_index=max_stringency
drop max_stringency
keep if date=="2021-03-21"
rename location country
keep iso_code country date total_cases_per_million total_deaths_per_million stringency_index mean_stringency total_tests_per_thousand mean_positive_rate population population_density aged_65_older gdp_per_capita hospital_beds_per_thousand life_expectancy 

*excess deaths
merge 1:1 country using "$data\excess_deaths.dta"
drop if _merge==2
drop _merge
order country

*BMI
merge 1:1 country using  "$data\bmi.dta"
drop if _merge==2
drop _merge
order country

*share of death by risk factors (including alcohol, obesity and smoking)
merge 1:1 country using  "$data\death_risk.dta"
drop if _merge==2
drop _merge
order country

*covid days since first death
merge 1:1 country using "$data\daysincovid.dta", keepusing(daysincovid)
drop if _merge==2
drop _merge

* mobility
merge 1:1 country using "$data\mobility.dta"
drop if _merge==2
drop _merge

* health expenditure per capita, PPP (2018)
merge 1:1 country using "$data\health_exp.dta"
drop if _merge==2
drop _merge

*Mortality before the pandemic
merge 1:1 country using "$data\mortality.dta"
drop if _merge==2
drop _merge

*Confidence in government and trust in people
merge 1:1 country using "$data\confidence_in_government.dta"
drop if _merge==2
drop _merge

*Data on tightness - following the rules https://www.thelancet.com/action/showPdf?pii=S2542-5196%2820%2930301-6
merge 1:1 country using "$data\tightness.dta"
drop if _merge==2
drop _merge

*GINI
merge 1:1 country using "$data\gini.dta"
drop if _merge==2
drop _merge

*World governance indicators
merge 1:1 country using "$data\wgi.dta"
drop if _merge==2
drop _merge

*Democracy 
merge 1:1 country using "$data\FH_democracy.dta"
drop if _merge==2
drop _merge

*Alternative observation periods
merge 1:1 country using "$data\alt_observation_periods.dta"
drop if _merge==2
drop _merge

*Corruption
merge 1:1 country using "$data\corruption.dta"
drop if _merge==2
drop _merge

*Migrant stock
merge 1:1 country using "$data\migrant_stock.dta"
drop if _merge==2
drop _merge

*No. of medical doctors
merge 1:1 country using "$data\no_of_medical_doctors.dta"
drop if _merge==2
drop _merge

*Cancer survival
merge 1:1 country using "$data\cancer_survival.dta"
drop if _merge==2
drop _merge

*Prison population data
merge 1:1 country using  "$data\prison_data.dta"
drop if _merge==2
drop _merge

*how comparable death registering policies are?
merge 1:1 country using  "$data\deaths_resiter_policy.dta"
drop if _merge==2
drop _merge

*excess death
merge 1:1 country using "$data\excess_deaths.dta"
drop _merge

*OECD countries
merge 1:1 country using "$data\oecd.dta"
drop _merge

*Stringency submeasure - restrictions on personal gatherings
merge 1:1 country using "$data\stringency_implementation.dta"
drop _merge


*Years of education
merge 1:1 country using  "$data\education.dta"
drop if _merge==2
drop _merge

*PISA scores
merge 1:1 country using  "$data\pisa.dta"
drop if _merge==2
drop _merge

*Falk et al data on economic preferences
merge 1:1 country using "$data\falk_et_al.dta"
drop if _merge==2
drop _merge

*Data on closures 
merge 1:1 country using  "$data\closure.dta"
drop _merge


******Variables********
*1.	Measures of economic, social and political development
rename 	gdp_per_capita	gdppercap
rename 	life_expectancy	lifeexp

*2. Health
*# Share of deaths by risk factor (IHME, 2019) /*Global Burden of Disease study: https://www.thelancet.com/gbd/summaries*/
rename 	dietaryrisksihme2019	drisk /*https://www.thelancet.com/pb-assets/Lancet/gbd/summaries/risks/dietary-risks.pdf*/
rename 	obesityihme2019	obesity
rename 	lowphysicalactivityihme2019	physact
rename 	smokingihme2019	smoking /*https://www.thelancet.com/pb-assets/Lancet/gbd/summaries/risks/smoking.pdf*/
rename 	alcoholuseihme2019	alcohol
rename 	highbloodsugarihme2019	bloodsug
rename 	highcholesterolihme2019	cholest
rename 	highbloodpressureihme2019	bloodpres
rename 	impairedkidneyfunctionihme2019	kidney
rename 	airpollutiontotalihme2019	airpoll

*Demography
rename 	aged_65_older	age65plus

*Resource of the health system
rename currenthealthexpenditurepercapit healthexp

*Environment
rename 	population	pop
rename 	population_density	pop_den

*Anti-pandemic measures
rename stringency_index stringency

*Mobility
rename	retail_and_recreation_percent_ch	mobretail
rename	grocery_and_pharmacy_percent_cha	mobpharm
rename	transit_stations_percent_change_	mobstations
rename	workplaces_percent_change_from_b	mobwork
egen mobility = rowmean(mobretail	mobpharm	mobstations	mobwork)

*Mortality per 1 million pax
sum total_mortality pop
gen mortality_rate=(total_mortality/pop)*1000000
gen log_mortality=ln((total_mortality/pop)*1000000)
sum total_mortality mortality_rate log_mortality

rename giniindexworldbank2016 gini

gen lnpop=ln(pop)
gen lnpop_den=ln(pop_den)
gen lndeaths=ln(total_deaths_per_million)
gen lncases = ln(total_cases_per_million)
gen fatality_rate=total_deaths_per_million/total_cases_per_million
gen lnfatality_rate=ln(fatality_rate)

gen lnexcess_deaths=ln(p_scores_all_ages)

sum confidence_*

local list confidence_in_press confidence_in_police confidence_in_parliament confidence_in_government confidence_in_parties confidence_in_justice
foreach item in `list' {
sum `item'
gen ST`item'=-(`item'-r(mean))/r(sd)
}

pca STconfidence_*

predict confidence_pca
sum confidence_pca
gen STconfidence_pca=(confidence_pca-r(mean))/r(sd)
drop if confidence_pca==.

*share of missing
egen confidence_missing=rowmean(confidence_in_press_missing confidence_in_police_missing confidence_in_parliament_missing confidence_in_government_missing confidence_in_parties_missing confidence_in_justice_missing)

sum confidence_missing

local list bmi alcohol obesity bloodsug cholest bloodpres kidney physact smoking airpoll
foreach item in `list' {
sum `item'
gen STH`item'=(`item'-r(mean))/r(sd)
}

pca  STH*
predict health_pca
sum health_pca

gen doctors_per_thousand=no_of_medical_doctors/pop*1000

local list healthexp hospital_beds_per_thousand doctors_per_thousand
foreach item in `list' {
sum `item'
gen STH2`item'=(`item'-r(mean))/r(sd)
}

pca  STH2*
predict healthsystem_pca
sum healthsystem_pca

sum trust_pca

gen ln_gdp=ln(gdppercap)

local list gov_effectiveness FH_score 
foreach item in `list' {
sum `item'
gen STG`item'=(`item'-r(mean))/r(sd)
}

pca STG*
predict political_pca
sum political_pca

*alternative observation periods - days since the first death
global n1 21/10/2020
global n2 21/11/2020
global n3 21/12/2020
global n4 21/01/2021
global n5 21/02/2021
global n6 21/03/2021

forval i=1/6 {
local day=(6-`i')*30
di "Day= `day'"
gen daysincovid`i'=daysincovid-`day'
}

gen ln_test=ln(total_tests_per_thousand)

*island dummy
gen island=0
replace island=1 if country=="Australia" | country=="Cyprus" | country==" Indonesia" | country=="Japan" |  ///
country=="New Zealand" | country==" Philippines" | country=="United Kingdom"

*contorolling for death registering policy
replace death_register=0 if death_register==.
tab death_register, gen(policy)

gen imp_cat=0
sum mean_implement 
replace imp_cat=1 if mean_implement>=r(mean) & mean_implement!=.

gen cont_cat=0
sum mean_contact
replace cont_cat=1 if mean_contact>=r(mean) & mean_contact!=.

do "$do\4_labels.do"

save "$github\database.dta", replace










