// Intro
clear
set memory 1000m
cd "C:\Users\Alex\Documents\EPP M2\LaborWasmer\Reg"

use "Job_Offers_Ile-de-France.dta"
*insheet excel  "Coordonnées + Data IRIS.xlsx"

// Nettoyage 

drop if longitude==0
drop if latitude==0
drop if latitude==.
drop if longitude==.
drop date
drop Description_
*drop if city==0
count

save "Job_Offers_Ile-de-France.dta",replace

// Gen variables en grad

generate latgrad = latitude*3.1415/180
generate longrad = longitude*3.1415/180

// Distance des offres par rapport à Paris
count if sqrt((0.8529244-latgrad)^2+(0.0406976-longrad)^2)*6371 < 6

gen distanceparis = sqrt((0.8529244-latgrad)^2+(0.0406976-longrad)^2)*6371

* Graph distance des offres par rapport à Paris
twoway scatter v2 distanceparis if distanceparis<100, ytitle(Number of job offers) xtitle(Distance to Paris)
twoway scatter v2 distanceparis if distanceparis<100 & v2<1500, ytitle(Number of job offers) xtitle(Distance to Paris)
twoway scatter v2 distanceparis if distanceparis<100 & distanceparis>10, ytitle(Number of job offers) xtitle(Distance to Paris)

// Regroupement des offres 0,10 et 20km

display sqrt(((48.856-50.63)*3.14/180)^2+((2.350-3.063)*3.14/180)^2)*6371

//Nombre d'observation par ville
order city
sort city-v1
gen v1=1
/*
gen v3=sum(v1)
drop v3
*->cumulative sum
egen v4=sum(v1)
drop v4
*-> normal sum
*/
by city : egen v2 = sum(v1)

//Nombre d'observations à 10km, 20km  
bysort distanceparis : egen v3 = sum(v1)
twoway scatter v3 distanceparis if distanceparis<100, ytitle(Number of job offers) xtitle(Distance to Paris)

*/
sqrt (2)
display sqrt(2)
help sqrt
help count 
help type 
help string 

help egen



sort ident12

save "fpr_menage_2012.dta", replace

use "fpr_mrf12e12t4.dta"

sort ident12

save "fpr_mrf12e12t4.dta", replace


merge ident12 using "fpr_mrf12e12t4.dta" "fpr_menage_2012.dta"

save "fpr-menageapp.dta"

help new

browse
describe
/*


// Market Tightness
