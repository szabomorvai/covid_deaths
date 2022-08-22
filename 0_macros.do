cap log close
log using "$logs\0_macros.smcl", replace

* Confidence in public institutions is critical in containing the COVID-19 pandemic
* Anna Adamecz-Völgyi and Ágnes Szabó-Morvai
* Last updated on 18 July 2022 

* Macros
* Anna
global covid "C:\Users\adamecz.anna\Dropbox\Covid 2021"
*Lili
*global covid "C:\Users\sarkadi-nagy.lili\Dropbox\Covid 2021"
* Agi
*global covid "C:\Users\szabomorvai.agnes\Dropbox\Research\Covid 2021"


*******************
* Data (only do files are provided, data files are downloadable)
*******************

*Our world in data data on deaths and control variables until 21 March 2021 (Downloaded on 21 March 2022 from ourworldindata.com)
global data "${covid}\ourworldindata data"
global source "${covid}\ourworldindata data\OWID\owid-datasets-master\datasets"

*Our world in data data on deaths and vaccination until 21 Dec 2021/01 Jan 2022 (Downloaded on 22 April 2022 from ourworldindata.com )
global newdata "$covid\DATA 2022.04.22\covid-19-data-master\public\data"

*Google mobility data (Downloaded on 21 March 2022 from ourworldindata.com)
global google "${covid}\Google_mobility_data"

*World value survey data (Downloaded on 21 March 2022 from ourworldindata.com)
global wvs "${covid}\World Value Survey 2017 2020"

*******************
* Analysis
*******************

global do "${covid}\do\github"
global results "${covid}\results"
global github "${covid}\do\github"
global logs "${covid}\do\github\logs"

cap log close