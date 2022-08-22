* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* 2021.05.25.


***********************************
**********Table B 2: FIML**********
***********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome lndeaths
rename STconfidence_pca stconfidence_pca
global var stconfidence_pca 
global table table_b2

*Outreg2 fails when producing medical-style output tables after sem - log file is produced
cap log close
log using "${results}\medical\\${table}", replace
sem ( $outcome <- $var $control1 ) ,  vce(robust) method(mlmv) difficult allmissing 
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(Model 1) dec(3) label word keep($var ${control1})
sleep 1000
forval i=2/7 {
sem ( $outcome <- $var  ${control`i'} ) , vce(robust) method(mlmv) difficult allmissing 
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , append ctitle(Model `i') dec(3) label word keep($var ${control`i'})
sleep 1000
}
cap log close

*Second item on Figure 2 (Model 7 in Table B 2)
sem ( $outcome <- $var  ${control7} ) , vce(robust) method(mlmv) difficult allmissing 
mat A2=(e(N),_b[stconfidence_pca],_se[stconfidence_pca])
mat rownames A2=Model_7_FIML
mat colnames A2=obs beta se
clear
svmat2 A2, names(col) rname(model)
gen low=beta-1.96*se
gen high=beta+1.96*se
save "$results\figure_2_A2.dta", replace

***********************************
**********Table B 3: Alternative outcomes, Model 6
***********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
local list lndeaths total_deaths_per_million lncases lnfatality_rate p_scores_all_ages lnexcess_deaths mean_positive_rate ln_test 
global table table_b3
local i=1
foreach item in `list' {
global outcome `item'
reg $outcome STconfidence_pca $control7, vce(robust)
mat B`i'=(e(N),_b[STconfidence_pca],_se[STconfidence_pca])
mat rownames  B`i'=`item'
if `i'==1 {
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(`item') dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(`item') dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
}
if `i'!=1 {
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , append ctitle(`item') dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , append ctitle(`item') dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
}
local i=`i'+1
}
*Third set of items on Figure 2 (Table B 3)
mat A3=B3\B4\B6
mat colnames A3=obs beta se
clear
svmat2 A3, names(col) rname(model)
gen low=beta-1.96*se
gen high=beta+1.96*se
save "$results\figure_2_A3.dta", replace

***********************************
**********Table B 4: Alternative confidence measures, Model 7*******
***********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome lndeaths 
local list STconfidence_pca STconfidence_in_press STconfidence_in_police STconfidence_in_parliament STconfidence_in_government STconfidence_in_parties STconfidence_in_justice 
global table table_b4
local i=1
foreach item in `list' {
reg $outcome `item' $control7 , vce(robust)
mat B`i'=(e(N),_b[`item'],_se[`item'])
mat rownames  B`i'=`item'
if `i'==1 {
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(Model 1) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(Model 1) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
}
if `i'!=1 {
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , append ctitle(Model 1) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , append ctitle(Model 1) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
}
local i=`i'+1
}
*Fourth set of items on Figure 2 (Table B 3)
mat A4=B2\B3\B4\B5\B6\B7
mat colnames A4=obs beta se
clear
svmat2 A4, names(col) rname(model)
gen low=beta-1.96*se
gen high=beta+1.96*se
save "$results\figure_2_A4.dta", replace

***********************************
**********Table B 5: Further robustness checks
***********************************
*Lasso 1: the lasso coeffs need to be put into the publication table manually
use "$github\database.dta", clear
do "$do\3b_controls.do"
foreach var of varlist confidence_pca $control7 {
	egen _sd`var' = sd(`var')
	egen _mean`var'=mean(`var')
	gen STL`var' = (`var'-_mean`var')/_sd`var'
}
drop _sd* _mean*
global outcome lndeaths
*Note that the list of important regressors needs to be extracted manually
cvlasso $outcome STL*  , nfolds(100) lopt seed(12345)
/*
Selected	Lasso   Post	
STLconfidence_pca       -0.739
STLdaysincovid        0.286
STLpolitical_pca        0.163
STLhealthsystem~a        0.474
STLhealth_pca        0.332
STLstringency        0.314
STLmobility       -0.237
Partialled-out*
_cons        5.8946968	5.8726996
*/			

*list of important regressors
global lasso1  daysincovid political_pca health_pca healthsystem_pca stringency mobility

*Lasso 2: individual measures instead of PCA indexes
* the lasso coeffs need to be put into the publication table manually
/*
use "$github\database.dta", clear
global controls confidence_pca healthexp hospital_beds_per_thousand doctors_per_thousand ///
bmi alcohol obesity bloodsug cholest bloodpres kidney physact smoking airpoll ///
daysincovid lnpop lnpop_den ln_gdp gini gov_effectiveness FH_score ///
log_mortality age65plus lifeexp migrant_stock trust_pca mobility stringency

foreach var of varlist $controls  {
	egen _sd`var' = sd(`var')
	egen _mean`var'=mean(`var')
	gen STL`var' = (`var'-_mean`var')/_sd`var'
}

drop _sd* _mean*
cvlasso $outcome STL*  , nfolds(100) lopt seed(12345)
*/

/*
Selected	Lasso	Post-est OLS
			
STLconfidence_pca       -0.600
STLhealthexp        0.441
STLdoctors_per_~d        0.236
STLbmi        0.056
STLobesity        0.544
STLbloodsug        0.099
STLkidney       -0.314
STLphysact        0.254
STLdaysincovid        0.265
STLlnpop_den        0.133
STLgov_effectiv~s       -0.274
STLFH_score        0.416
STLlifeexp       -0.155
STLmigrant_stock       -0.177
STLmobility       -0.378
STLstringency        0.131
			
Partialled-out*
			
_cons        5.8963363	5.8738467			
*/

global lasso2 healthexp doctors_per_thousand bmi obesity bloodsug kidney physact daysincovid lnpop_den gov_effectiveness FH_score lifeexp migrant_stock mobility stringency

*regressions
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome lndeaths 
global var STconfidence_pca
global table table_b5

*baseline model
reg $outcome $var $control7 , vce(robust)
global title "Model 7"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")

*excluding countries collecting data on confidence in March-Aug 2020 (i.e., after 1 March 2020)
reg $outcome $var $control7 if interview_share==0 , vce(robust)
mat B1=(e(N),_b[${var}],_se[${var}])
mat rownames  B1=excl_data
global title "Data collection"
do "$do\5d_outreg2.do"

*weighting by population
reg $outcome $var $control7 [aw=pop] , vce(robust)
mat B2=(e(N),_b[${var}],_se[${var}])
mat rownames  B2=weighted
global title "Weighted"
do "$do\5d_outreg2.do"

*controlling for the share of missing values of confidence measures per countries
reg $outcome $var $control7  confidence_missing , vce(robust)
mat B3=(e(N),_b[${var}],_se[${var}])
mat rownames  B3=missing_conf
global title "nonresponse"
do "$do\5d_outreg2.do"

*Lasso1
reg $outcome $var $lasso1 , vce(robust)
mat B4=(e(N),_b[${var}],_se[${var}])
mat rownames  B4=lasso1
global title "lasso1"
do "$do\5d_outreg2.do"

*Lasso2
reg $outcome $var $lasso2 , vce(robust)
mat B5=(e(N),_b[${var}],_se[${var}])
mat rownames  B5=lasso2
global title "lasso2"
do "$do\5d_outreg2.do"

*Mean stringency instead of max
reg $outcome $var $control5 mean_stringency mobility , vce(robust)
mat B6=(e(N),_b[${var}],_se[${var}])
mat rownames  B6=mean_stringency
global title "mean_stringency"
do "$do\5d_outreg2.do"

*democracy sample
reg $outcome $var $control7 if democracy==1 , vce(robust)
mat B7=(e(N),_b[${var}],_se[${var}])
mat rownames  B7=democracy
global title "Democracy subsample"
do "$do\5d_outreg2.do"

*OECD sample
reg $outcome $var $control7 if oecd==1 , vce(robust)
mat B8=(e(N),_b[${var}],_se[${var}])
mat rownames  B8=oecd
global title "OECD subsample"
do "$do\5d_outreg2.do"

*Fifth set of items on Figure 2 (Table B 4)
mat A5=B1\B2\B3\B4\B5\B6\B7\B8
mat colnames A5=obs beta se
clear
svmat2 A5, names(col) rname(model)

gen low=beta-1.96*se
gen high=beta+1.96*se

save "$results\figure_2_A5.dta", replace

***********************************
**********Table B 6: Further control variables
***********************************
*Table B6
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome lndeaths 
global var STconfidence_pca
global table table_b6


*controlling for corruption
local i=1
reg $outcome $var $control7  nocorruption_score_2019 ,  vce(robust) 
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=corruption
global title "Corruption"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
sleep 1000

*Island dummy
local i=`i'+1
reg $outcome $var $control7 island , vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=island
global title "Island"
do "$do\5d_outreg2.do"
sleep 1000

*controlling for education
local i=`i'+1
reg $outcome $var $control7 yearsofedu, vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=education
global title "Education"
do "$do\5d_outreg2.do"
sleep 1000

*Closing measures
local i=`i'+1
reg $outcome $var $control7 max_closing mean_closing sd_closing, vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=closure
global title "Closure"
do "$do\5d_outreg2.do"
sleep 1000

*Definition of death
local i=`i'+1
reg $outcome $var $control7 policy2 policy3 policy4 , vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=death_defs
global title "Definition of deaths"
do "$do\5d_outreg2.do"
sleep 1000

*controlling for the ln No. of tests per thousand people
local i=`i'+1
reg $outcome $var $control7  ln_test, vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=tests
global title "No. of tests"
do "$do\5d_outreg2.do"
sleep 1000

*controlling for tightness
local i=`i'+1
reg $outcome $var $control7  tightness, vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=tightness
global title "Tightness"
do "$do\5d_outreg2.do"
sleep 1000

*cancer survival
local i=`i'+1
reg $outcome $var $control7  breast,  vce(robust) 
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=breast
global title "Breast"
do "$do\5d_outreg2.do"
sleep 1000

*próba: voter turnout
local i=`i'+1
reg $outcome $var $control7  voterturnout ,  vce(robust) 
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=voter
global title "Voter"
do "$do\5d_outreg2.do"
sleep 1000

*Sixth set of items on Figure 2 (Table B 6)
mat A6=B1\B2\B3\B4\B5\B6\B7\B8\B9
mat colnames A6=obs beta se
clear
svmat2 A6, names(col) rname(model)
gen low=beta-1.96*se
gen high=beta+1.96*se
save "$results\figure_2_A6.dta", replace

*************************************
**********Table C1: Outcome, vaccination rate (OLS)
*************************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global outcome vaccination_rate
global var STconfidence_pca 
global table "table_c1"

reg $outcome $var , vce(robust)
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

***********************************
**********Table B 7: Alternative observation periods
***********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global table table_b7
global var STconfidence_pca
reg Alndeath1 $var $control7 , vce(robust)
mat B1=(e(N),_b[${var}],_se[${var}])
mat rownames  B1=Alndeath1
global title "AOLS 1"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
sleep 1000
forval i=2/6 {
reg Alndeath`i' $var $control7 , vce(robust)
mat B`i'=(e(N),_b[${var}],_se[${var}])
mat rownames  B`i'=Alndeath`i'
global title "AOLS `i'"
do "$do\5d_outreg2.do"
}

*Seventh set of items on Figure 2 (Table B 7)
mat A7=B1\B2\B3\B4\B5
mat colnames A7=obs beta se
clear
svmat2 A7, names(col) rname(model)
gen low=beta-1.96*se
gen high=beta+1.96*se
save "$results\figure_2_A7.dta", replace

***********************************
**********Figure B 1: Random forest variable importance
***********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
set seed 123555
rforest lndeaths confidence_pca $control7 , type(reg) iter(10000)
*importance matrix
mat A=e(importance)    
mat list A
clear
svmat2 A, rnames(var) names(col)
gsort -Variable
gen sor=_n
sencode var, gen(varcode) gsort(sor)

/*Variable	var	sor	varcode
1	confidence_pca	1	confidence_pca
.8772987	health_pca	2	health_pca
.8464907	daysincovid	3	daysincovid
.7788535	stringency	4	stringency
.7564267	mobility	5	mobility
.753588	log_mortality	6	log_mortality
.7311158	political_pca	7	political_pca
.6797574	migrant_stock	8	migrant_stock
.6777341	ln_gdp	9	ln_gdp
.6620838	age65plus	10	age65plus
.6123538	lnpop	11	lnpop
.6113969	healthsystem_pca	12	healthsystem_pca
.610045	lnpop_den	13	lnpop_den
.6065656	lifeexp	14	lifeexp
.5724282	trust_pca	15	trust_pca
.3762423	gini	16	gini
*/

lab def lvarcode ///
1 "Confidence in institutions" ///
2 "Index of health risks" ///
3 "No. of days since first death"  ///
4  "Stringency" ///
5 "Mobility" ///
6 "Log mortality rate before the pandemic" ///
7  "Index of democracy and government effectiveness" ///
8  "Share of immigrants" /// 
9  "Log GDP per capita" ///
10 "Share of those aged 65" ///
11 "Log population"  ///
12  "Resources of the health system" ///
13 "Log population density" ///
14 "Life expectancy" ///
15  "Trust in others" ///
16 "Gini" 
lab val varcode lvarcode
twoway bar Variable varcode, ylabel(1(1)16, angle(horizontal) labsize(vsmall)) ylabel(, valuelabel) hor ///
ytitle("") xtitle("Predictive importance") graphregion(color(white)) xlabel(0.3(0.1)1) 
graph export "$results\rforest_1.png" , as(png) replace

****************************************************
*Using individual measures instead of PCA on the RHS
****************************************************
global outcome lndeaths 
global var STconfidence_pca
use "$github\database.dta", clear
global controls healthexp hospital_beds_per_thousand doctors_per_thousand ///
bmi alcohol obesity bloodsug cholest bloodpres kidney physact smoking airpoll ///
daysincovid lnpop lnpop_den ln_gdp gini gov_effectiveness FH_score ///
log_mortality age65plus lifeexp migrant_stock trust_pca stringency mobility
foreach item in $controls {
sum `item'
gen STRF_`item'=(`item'-r(mean))/r(sd)
}
set seed 123555
rforest $outcome $var STRF_* , type(reg) iter(10000)
*importance matrix
mat A=e(importance)    
mat list A
clear
svmat2 A, rnames(var) names(col)
gsort -Variable
gen sor=_n
sencode var, gen(varcode) gsort(sor)

/*
Variable	var	sor	varcode
1	STRF_bmi	1	STRF_bmi
.8428378	STconfidence_pca	2	STconfidence_pca
.7836007	STRF_obesity	3	STRF_obesity
.7569412	STRF_FH_score	4	STRF_FH_score
.7262306	STRF_daysincovid	5	STRF_daysincovid
.7075225	STRF_physact	6	STRF_physact
.6799302	STRF_mobility	7	STRF_mobility
.6643139	STRF_log_mortality	8	STRF_log_mortality
.6626596	STRF_stringency	9	STRF_stringency
.6528428	STRF_cholest	10	STRF_cholest
.6483383	STRF_healthexp	11	STRF_healthexp
.6218541	STRF_doctors_per_thousand	12	STRF_doctors_per_thousand
.6216263	STRF_bloodpres	13	STRF_bloodpres
.6175897	STRF_airpoll	14	STRF_airpoll
.6006762	STRF_ln_gdp	15	STRF_ln_gdp
.5777777	STRF_migrant_stock	16	STRF_migrant_stock
.5596	STRF_age65plus	17	STRF_age65plus
.5310167	STRF_bloodsug	18	STRF_bloodsug
.520954	STRF_lnpop_den	19	STRF_lnpop_den
.5179352	STRF_lifeexp	20	STRF_lifeexp
.5160168	STRF_trust_pca	21	STRF_trust_pca
.5143949	STRF_lnpop	22	STRF_lnpop
.5074825	STRF_alcohol	23	STRF_alcohol
.5053205	STRF_kidney	24	STRF_kidney
.4724824	STRF_smoking	25	STRF_smoking
.4580582	STRF_gov_effectiveness	26	STRF_gov_effectiveness
.4166026	STRF_hospital_beds_per_thousand	27	STRF_hospital_beds_per_thousand
.3227331	STRF_gini	28	STRF_gini
*/

lab def lvarcode ///
1 "BMI" ///
2 "Confidence in institutions" ///
3 "Obesity" ///
4 "FH democracy score" ///
5 "No. of days since first death"  ///
6 "Lack of physical activity"  ///
7 "Mobility" ///
8 "Log mortality rate before the pandemic" ///
9 "Stringency" ///
10 "High cholesterol" ///
11 "Health expenditures" ///
12 "No. of doctors" ///
13 "High blood pressure" ///
14 "Air pollution" ///
15  "Log GDP per capita" ///
16 "Share of immigrants" /// 
17 "Share of those aged 65" ///
18  "High blood sugar" ///
19 "Log population density" ///
20 "Life expectancy" ///
21 "Trust in others" ///
22 "Log population"  ///
23 "Alcohol"  ///
24 "Chronic kindey disease"  ///
25 "Smoking"  ///
26  "Government effectiveness" ///
27 "No. of hospital beds" ///
28 "Gini"

lab val varcode lvarcode
twoway bar Variable varcode, ylabel(1(1)28, angle(horizontal) labsize(vsmall)) ylabel(, valuelabel) hor ///
ytitle("") xtitle("Predictive importance") graphregion(color(white)) xlabel(0.3(0.1)1) 
graph export "$results\rforest_2.png" , as(png) replace

**************************************
*ALternative random samples of countries - Figure B 2
*************************************
set seed 123456789
set matsize 11000 
do "$do\3b_controls.do"
local j=5000
forval i=1/`j' {
qui {
use "$github\database.dta", clear
global outcome lndeaths 
global var STconfidence_pca
qui reg $outcome $var $control7
keep if e(sample)==1
sample 63
qui reg $outcome $var $control7 , vce(robust)
mat A_`i'=(`i',e(N), _b[STconfidence_pca], _se[STconfidence_pca])
if `i'==1 {
mat A=A_`i'
}
if `i'!=1 {
mat A=A\A_`i'
}
noisily di "`i' is done"
}
}
mat colnames A=i obs beta se
mat list A
clear
svmat A, names(col)
save "$results\beta.dta", replace
hist beta, normal xline(0.828, lstyle(foreground)) freq xtitle("Beta") graphregion(color(white))
sum beta
local low=r(mean)-1.96*r(sd)
local high=r(mean)+1.96*r(sd)
graph twoway (hist beta) (scatteri 0 -0.828 2 -0.828, c(l) m(i)) /// 
,  legend(label(1 "Estimated betas, No. of countries=35") label(2 "Main estimate, No. of countries=55") col(1)) ///
graphregion(color(white)) 
graph save "$results\figure_b2.gph", replace 

********************
****Figure 2****
********************
clear
forval i=1/7 {
append using "$results\figure_2_A`i'.dta"
}
gen sor=_n
order sor model
sor	model
lab def lsor ///
1	"1. Model 7 OLS"  ///
2	"2. Model 7 FIML" ///
3	"3. Outcome: ln total cases" ///
4	"4. Outcome: ln fatality rate" ///
5	"5. Outcome: ln excess deaths" ///
6	"6. Confidence in press" ///
7	"7. Confidence in police" ///
8	"8. Confidence in parliament" ///
9	"9. Confidence in government" ///
10	"10. Confidence in parties" ///
11	"11. Confidence in justice" ///
12	"12. Excluding late data collection" ///
13	"13. Weighted by population" ///
14	"14. Controlling for missing confidence data" ///
15	"15. Lasso controls 1" ///
16	"16. Lasso controls 2" ///
17	"17. Controlling for mean stringency"	 ///
18	"18. Democracies" ///
19	"19. OECD subsample" ///
20	"20. Controlling for corruption" ///
21	"21. Controlling for island" ///
22	"22. Controlling for education" ///
23 "23. Controlling for closure measures" ///
24	"24. Controlling for definitions of deaths" ///
25	"25. Controlling for the No. of tests" ///
26	"26. Controlling for tightness" ///
27	"27. Controlling for breast cancer survival" ///
28 "28. Controlling for voter turnover" ///
29	"29. Period until 21 Oct 2020" ///
30	"30. Period until 21 Nov 2020" ///
31	"31. Period until 21 Dec 2020" ///
32	"32. Period until 21 Jan 2021" ///
33	"33. Period until 21 Feb 2021"

lab val sor lsor
decode sor, gen(sor_str)
gsort -obs
gen sor3=_n
sencode sor_str, gen(sor2) label(sor_str) gsort(sor3)
twoway (scatter beta sor , mlabel(obs) mlabsize(vsmall) mlabposition(1)) ////
(rcap high low sor), xlabel(1(1)32, val angle(90) labsize(vsmall)) ///
legend(label(1 "Estimated coefficients (sample size is above on the right)") label(2 "95% confidence intervals") col(1) size(small)) ///
graphregion(color(white)) xtitle("") ytitle("Estimated coefficients", size(small)) yline(0) xline(2.5 5.5 11.5 28.5 , lcol(grey) lpattern(dash)) ///
text(1.2 1.5 "Main", size(small)) text(1.2 4 "Out-" "comes", size(small)) text(1.2 8.5 "Confidence def.", size(small)) text(1.2 18 "Robustness checks", size(small)) text(1.2 31 "End of period", size(small))
graph export "$results\figure_2.png", as(png) replace