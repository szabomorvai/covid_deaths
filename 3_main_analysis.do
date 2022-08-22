* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* 2021.05.25.

*************************************
**********Table 1 and Table B 1: Main results (OLS)
*************************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome lndeaths
global var STconfidence_pca 
global table "table_b1"

reg $outcome $var $control1, vce(robust)
*Economics-style output table
*outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(Model 1) dec(3) label word
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(Model 1) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")

gen minta1=e(sample)

forval i=2/7 {
reg $outcome $var ${control`i'}, vce(robust)
gen minta`i'=e(sample)
*outreg2 using "${results}\economics\\${table}.doc" , append ctitle("Model `i'") dec(3) label word
outreg2 using "${results}\medical\\${table}.doc" , append ctitle("Model `i'") dec(3) label stat(coef ci pval) bracket(ci) paren(pval) word noaster nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")

if `i'==7 {
global table table_1
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(Model 7) dec(3) label side stat(coef ci pval) bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
}
}


*First item on Figure 2 (Model 7 in Table B1)
reg $outcome $var ${control7}, vce(robust)
mat A1=(e(N),_b[STconfidence_pca],_se[STconfidence_pca])
mat rownames A1=Model_7_OLS
mat colnames A1=obs beta se
clear
svmat2 A1, names(col) rname(model)

gen low=beta-1.96*se
gen high=beta+1.96*se

save "$results\figure_2_A1.dta", replace

**************************************
**********Table A 2: List of countries
**************************************
use "$github\database.dta", clear
do "$do\3b_controls.do"

global outcome lndeaths
global var STconfidence_pca 

forval i=1/7 {
reg $outcome $var ${control`i'}, vce(robust)
gen minta`i'=e(sample)
}

reg $outcome $var $control7 if democracy==1 
gen minta8=e(sample)

reg $outcome $var $control7 if oecd==1 
gen minta9=e(sample)

keep country country iso_code fw_end interview_share minta*
export excel using "$results\table_a2.xls", firstrow(variables) replace

********************
***Table A 3 - Descriptive statistics - ÚJRA hogy benne legyen a vaccination rate
********************
use "$github\database.dta", clear
cap erase descriptives.doc
do "$do\3b_controls.do"
do "$do\4_labels.do"

*main variables
local list1 lndeaths total_deaths_per_million lncases lnfatality_rate p_scores_all_ages lnexcess_deaths mean_positive_rate vaccination_rate STconfidence_pca

local list2 STconfidence_in_press STconfidence_in_police ///
STconfidence_in_parliament STconfidence_in_government  ///
STconfidence_in_parties STconfidence_in_justice 

local list3 breast prison_rate policy* yearsofedu  ///
 max_closing mean_closing sd_closing

asdoc sum `list1' `list2' ${control7} `list3' stringency mean_stringency mean_implement imp_cat mean_contact cont_cat confidence_missing Alndeath1-Alndeath5 mean_implement ln_test nocorruption_score_2019 voterturnout, label save(${results}\descriptives.doc) replace 

asdoc corr STconfidence_pca STconfidence_in_press STconfidence_in_police STconfidence_in_parliament STconfidence_in_government STconfidence_in_parties STconfidence_in_justice, label save(${results}\correlation.doc) replace

********************
*Figure 1***********
********************
use "$github\database.dta", clear
twoway (lfitci lndeaths STconfidence_pca, fintensity(inten10))  || ///
(scatter lndeaths STconfidence_pca, mlabel(iso_code) mlabcolor(gs5) mlabsize(small) mcolor(gs5) msize(vsmall)) , ///
xtitle("Confidence in institutions (standardized)") ytitle("Log COVID-19 deaths per million") graphregion(color(white)) ///
legend(off) title("All countries", color(black)) ylabel(0(2)10)

graph export "$results\figure_1A.png", as(png) replace

twoway (lfitci lndeaths STconfidence_pca if democracy==1, fintensity(inten10))  || ///
(scatter lndeaths STconfidence_pca if democracy==1, mlabel(iso_code) mlabsize(small) mlabcolor(gs5) mcolor(gs5) msize(vsmall)) , ///
xtitle("Confidence in institutions (standardized)") ytitle("Log COVID-19 deaths per million") graphregion(color(white)) ///
legend(off) title("Democracies", color(black)) ylabel(0(2)10)

graph export "$results\figure_1B.png", as(png) replace


