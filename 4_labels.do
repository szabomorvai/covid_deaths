lab var mobility "Decrease in mobility"
lab var log_mortality "Log mortality rate before the pandemic"
lab var lndeaths "Ln total deaths per million"
lab var lncases "Ln total cases per million"
lab var p_scores_all_ages "Excess deaths in 2020"
lab var lnexcess_deaths "Log excess deaths"
lab var lnpop "Log population"
lab var lnpop_den "Log population density"
lab var total_deaths_per_million "Total deaths per million"
lab var breast "Survival rate of breast cancer"
lab var prison_rate "Prison population per 100,000"

local list  police parliament government parties justice press
foreach item in `list' {
lab var STconfidence_in_`item' "Confidence in `item'"
}

lab var STconfidence_pca "Confidence in institutions, standardized"

*share of missings
lab var confidence_missing "Data on confidence missing"
label var confidence_in_press_missing "Confidence in government, missing"
label var confidence_in_police_missing "Confidence in police, missing"
label var confidence_in_parliament_missing "Confidence in parliament, missing"
label var confidence_in_government_missing "Confidence in government, missing"
label var confidence_in_parties "Confidence in political parties, missing"
label var confidence_in_justice_missing "Confidence in justice/courts, missing"

lab var trust_pca "Trust in others, PCA score"
lab var interview_share "Share of interviews conducted after 01 March 2020"

lab var health_pca "Index of health risks"
lab var doctors_per_thousand "No. of doctors per thousand"
lab var healthsystem_pca "Resources of the health system"
lab var trust_pca "Trust in others"
lab var ln_gdp "Log GDP per capita"
lab var political_pca "Index of democracy and government effectiveness"
lab var yearsofedu "Years of schooling"


*alternative observation periods - days since the first death
global n1 21/10/2020
global n2 21/11/2020
global n3 21/12/2020
global n4 21/01/2021
global n5 21/02/2021
global n6 21/03/2021

forval i=1/6 {
lab var daysincovid`i' "No. of days since first death until ${n`i'}"
}

lab var ln_test "Log No. of tests per thousand people"
lab var nocorruption_score_2019 "TI lack of corruption score"

lab var daysincovid "No. of days since first death"
lab  var gini "Gini"
lab var age65plus "Share of those above age 65"
lab var lifeexp "Life expectancy"
lab var stringency "Stringency of COVID-19 measures"
lab var mean_stringency "Mean stringency of COVID-19 measures"
lab var tightness "Tightness of culture in following rules"
lab var migrant_stock "Share of migrants"

lab var policy1 "Definition of deaths: no info"
lab var policy2 "Clinical diagnosis-based definition of deaths"
lab var policy3 "Test-based definition of deaths"
lab var policy4 "Clinical and test-based definition of deaths"

lab var imp_cat "Restrictions on personal gatherings, binary"
lab var cont_cat "Comprehensive contact tracing, binary"
lab var mean_implement "Restrictions on personal gatherings"
lab var mean_contact "Comprehensive contact tracing"

lab var Alndeath1 "Log deaths by 2020-10-21"
lab var Alndeath2 "Log deaths by 2020-11-21"
lab var Alndeath3 "Log deaths by 2020-12-21"
lab var Alndeath4 "Log deaths by 2021-01-21"
lab var Alndeath5 "Log deaths by 2021-02-21"
lab var Alndeath6 "Log deaths by 2021-03-21"
lab var Alndeath_1june2020 "Log deaths by 2020-06-01"

lab var max_closing "Closing measures, max"
lab var mean_closing "Closing measures, mean"
lab var sd_closing "Closing measures, sd"

