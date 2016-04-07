clear
capture log using "/Users/sandrafronteau/Documents/labour/results/$S_DATE $S_TIME.log", replace
*set mem 700m if earlier version of stata (<stata 12)
set more off

cd "/Users/sandrafronteau/Documents/labour/"

*-------------------------------------------------------------------------------
*CREATE .DTA FROM MASTERFILE
clear
import excel using "masterfile3.xlsx", firstrow
drop wkt_geom
rename NOM_COM city
rename COUNT_JobOffers v
rename L department
rename M IDF_LIBCOM
rename N POP1564
rename O POP1524
rename P ACT1564
rename Q ACT1524
rename R u
rename S CHOM1524
rename IRISGEOWSG842_XCOORD longitude
rename IRISGEOWSG842_YCOORD latitude

order city NOM_IRIS
sort city-latitude
drop if u==.

by city : egen v2 = sum(v)
by city : egen u2= sum(u)

save "masterfile3.dta", replace

*-------------------------------------------------------------------------------
//Market tightness
gen MATIRIS=v/u
replace MATIRIS=0 if MATIRIS==.
gen MATcity=v2/u2
replace MATcity=0 if MATcity==.
save "masterfile3.dta", replace
*-------------------------------------------------------------------------------

use "masterfile3.dta", clear


// Gen variables en grad

destring longitude latitude, replace
generate latgrad = latitude*3.1415/180
generate longrad = longitude*3.1415/180


// Coor centre de Paris

*gen Parislat = 48.856614*3.1415/180
*gen Parislong= 2.3522219000000177*3.1415/180

gen Parislat = 48.869194*3.1415/180
gen Parislong= 2.331164*3.1415/180
*Coordinates for Paris 2e arrondissement where there is a concentration of job vacancies v (31540)

// Distance des offres par rapport à Paris
count if sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371 < 6

gen distanceparis = sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371

// Regroupement des offres 0,10 et 20km

egen v0=sum(v) if distanceparis<=1
replace v0=0 if v0==.
egen v5=sum(v) if distanceparis<=5 & distanceparis>1
replace v5=0 if v5==.
egen v10=sum(v) if distanceparis<=10 & distanceparis>5
replace v10=0 if v10==.
egen v20=sum(v) if distanceparis<=20 & distanceparis>10
replace v20=0 if v20==.
egen v35=sum(v) if distanceparis<=35 & distanceparis>20
replace v35=0 if v35==.

*Même chose pour le nombre de chômeurs

egen u0=sum(u) if distanceparis<=1
replace u0=0 if u0==.
egen u5=sum(u) if distanceparis<=5 & distanceparis>1
replace u5=0 if u5==.
egen u10=sum(u) if distanceparis<=10 & distanceparis>5
replace u10=0 if u10==.
egen u20=sum(u) if distanceparis<=20 & distanceparis>10
replace u20=0 if u20==.
egen u35=sum(u) if distanceparis<=35 & distanceparis>20
replace u35=0 if u35==.


//Graph distance des offres par rapport à Paris
*IRIS
twoway scatter v distanceparis, ytitle(Number of job offers) xtitle(Distance to Paris) title(Job offers and distance to Paris)
twoway scatter v distanceparis if distanceparis<110 & v<700 & v>0,xlabel(0(25)110) ylabel(0(200)700) ytitle(Number of job offers) xtitle(Distance to Paris) title(Job offers and distance to Paris)

*Cities
twoway scatter v2 distanceparis, ytitle(Number of job offers) xtitle(Distance to Paris) title(Job offers and distance to Paris)
twoway scatter v2 distanceparis if distanceparis<110 & v2<700 & v2>0,xlabel(0(25)110) ylabel(0(200)700) ytitle(Number of job offers) xtitle(Distance to Paris) title(Job offers and distance to Paris)

//Graph distance des job seekers par rapport à Paris
twoway scatter u distanceparis ,xlabel(0(25)110) ytitle(Number of job seekers) xtitle(Distance to Paris) title(Job seekers and distance to Paris)

//Graph job seekers population
twoway scatter u  POP1564, ytitle(Number of job seekers) xtitle(Population 15-64) title(Job seekers and population)

//Graphique distance market tightness par rapport à Paris
twoway scatter MATIRIS distanceparis, ytitle(Market Tightness) xtitle(Distance to Paris) title(Market tightness and Distance to Paris)
twoway scatter MATIRIS distanceparis if MATIRIS <8 & MATIRIS>0, xlabel(0(25)135) ytitle(Market Tightness) xtitle(Distance to Paris) title(Market tightness and Distance to Paris)
twoway scatter MATIRIS distanceparis if MATIRIS <4 & MATIRIS>0, xlabel(0(25)135) ytitle(Market Tightness) xtitle(Distance to Paris) title(Market tightness and Distance to Paris)


save "masterfile.dta", replace


set more on
log close
