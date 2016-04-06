clear
capture log using "/Users/sandrafronteau/Documents/labour/results/$S_DATE $S_TIME.log", replace
*set mem 700m if earlier version of stata (<stata 12)
set more off

cd "/Users/sandrafronteau/Documents/labour/"

*-------------------------------------------------------------------------------
*CREATE .DTA FROM MASTERFILE
clear
import excel using "masterfile.xlsx", firstrow
drop wkt_geom
drop Tauxchom
rename Couchejointe_count v
rename O IDF_DEP
rename P IDF_LIBCOM
rename Q POP1564
rename R POP1524
rename S ACT1564
rename T ACT1524
rename U u
rename V CHOM1524
rename NOM_COM city

order city NOM_IRIS
sort city-MarketTightness

by city : egen v2 = sum(v)

save "masterfile.dta", replace

*-------------------------------------------------------------------------------

use "masterfile.dta", clear


// Gen variables en grad
rename IRISGEOWSG842_XCOORD longitude
rename IRISGEOWSG842_YCOORD latitude
destring longitude latitude, replace
generate latgrad = latitude*3.1415/180
generate longrad = longitude*3.1415/180


*gen Parislat = 48.87041*3.1415/180
*gen Parislong= 2.331867*3.1415/180

// Coor centre de Paris

gen Parislat = 48.856614*3.1415/180
gen Parislong= 2.3522219000000177*3.1415/180

// Distance des offres par rapport ˆ Paris
count if sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371 < 6

gen distanceparis = sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371

// Regroupement des offres 0,10 et 20km
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


//Graph distance des offres par rapport ˆ Paris

twoway scatter v distanceparis, ytitle(Number of job offers) xtitle(Distance to Paris)
twoway scatter v distanceparis if distanceparis<110 & v<700, ytitle(Number of job offers) xtitle(Distance to Paris)

//Graphique distance market tightness par rapport à Paris
twoway scatter MarketTightness distanceparis, ytitle(Market Tightness) xtitle(Distance to Paris) title(Market tightness and Distance to Paris)
twoway scatter MarketTightness distanceparis if MarketTightness <8, xlabel(0(50)135) ytitle(Market Tightness) xtitle(Distance to Paris) title(Market tightness and Distance to Paris)


save "masterfile.dta", replace

set more on
log close
