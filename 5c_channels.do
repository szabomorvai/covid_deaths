* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* 2021.05.25.

set matsize 11000 

**********************************
*Alternative outcomes - Table B 8
**********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global table table_b8
global var STconfidence_pca
global outcome lndeaths 
reg breast $var $control5 , vce(robust)
global title "Breast"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
sleep 1000
reg prison_rate $var $control5 , vce(robust)
global title "Prison"
do "$do\5d_outreg2.do"
sleep 1000
reg mobility $var $control5 , vce(robust)
global title "Mobility"
do "$do\5d_outreg2.do"
sleep 1000

**********************************
*Submeasures of stringency - Table B 9
**********************************
use "$github\database.dta", clear
do "$do\3b_controls.do"
global table table_b9
global var STconfidence_pca
global outcome lndeaths 

*stringency measure subindex: restrictions on personal gatherings
reg lndeaths STconfidence_pca $control5 mobility mean_implement , vce(robust)
global title "Restrictions"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
sleep 1000
reg lndeaths c.STconfidence_pca##c.mean_implement $control5 mobility , vce(robust)
global title "Restrictions"
do "$do\5d_outreg2.do"
sleep 1000
reg lndeaths c.STconfidence_pca##imp_cat $control5 mobility , vce(robust)
global title "Restrictions"
do "$do\5d_outreg2.do"
sleep 1000

*stringency measure subindex: contact tracing
reg lndeaths STconfidence_pca $control5 mobility mean_contact , vce(robust)
global title "Contact tracing"
do "$do\5d_outreg2.do"
sleep 1000
reg lndeaths c.STconfidence_pca##c.mean_contact $control5 mobility , vce(robust)
global title "Contact tracing"
do "$do\5d_outreg2.do"
sleep 1000
reg lndeaths c.STconfidence_pca##cont_cat $control5 mobility , vce(robust)
global title "Contact tracing"
do "$do\5d_outreg2.do"
sleep 1000

**********************************
*Quantile regression - Table B 10
*********************************
use "$data\database.dta", clear
do "$do\3b_controls.do"
global table table_b10
global outcome lndeaths 
global var STconfidence_pca
qreg $outcome $var $control7 ,   quantile(0.2) vce(robust)  
global title "20st percentile"
*Economics-style output table
outreg2 using "${results}\economics\\${table}.doc" , replace ctitle(${title}) dec(3) label word 
*Medical-style output table 
outreg2 using "${results}\medical\\${table}.doc" , replace ctitle(${title}) dec(3) label stat(coef ci pval)  bracket(ci) paren(pval) noaster word nonotes addnote("Robust p-values in parentheses, 95% confidence intervals in brackets.")
sleep 1000
qreg $outcome $var $control7 ,   quantile(0.4) vce(robust)   
global title "40st percentile"
do "$do\5d_outreg2.do"
sleep 1000
qreg $outcome $var $control7 ,   quantile(0.6) vce(robust)   
global title "60st percentile"
do "$do\5d_outreg2.do"
sleep 1000
qreg $outcome $var $control7 ,   quantile(0.8) vce(robust)   
global title "80st percentile"
do "$do\5d_outreg2.do"
sleep 1000