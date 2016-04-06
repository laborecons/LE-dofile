// Intro
clear
set memory 1000m
cd "C:\Users\Alex\Documents\EPP M2\LaborWasmer\Reg"

use "Job_Offers_Ile-de-France.dta"
*insheet excel  "Coordonnées + Data IRIS.xlsx"

// Nettoyage 
global var_all "Sector city ID_Job Jobtitle Company Jobtype Description_"
foreach i of global var_all {
decode `i', generate(`i'2)
drop `i'
rename `i'2 `i'
}
drop if longitude==0
drop if latitude==0
drop if longitude==.
drop if latitude==.
drop date
drop Description_
drop if city=="0"

order city Sector Jobtitle Jobtype Company
sort city-ID_Job

count

save "Job_Offers_Ile-de-France.dta",replace

// Gen variables en grad

gen Parislat = 48.87041*3.1415/180
gen Parislong= 2.331867*3.1415/180

// Coor centre de Paris

gen Parislat = 48.856614*3.1415/180
gen Parislong= 2.3522219000000177*3.1415/180

// Distance des offres par rapport à Paris
count if sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371 < 6

gen distanceparis = sqrt((Parislat-latgrad)^2+(Parislong-longrad)^2)*6371


* Graph distance des offres par rapport à Paris
twoway scatter v2 distanceparis if distanceparis<100, ytitle(Number of job offers) xtitle(Distance to Paris)
twoway scatter v2 distanceparis if distanceparis<100 & v2<1500, ytitle(Number of job offers) xtitle(Distance to Paris)
twoway scatter v2 distanceparis if distanceparis<100 & distanceparis>10, ytitle(Number of job offers) xtitle(Distance to Paris)

// Regroupement des offres 0,10 et 20km
egen v10=sum(v1) if distanceparis<=10
replace v10=0 if v10==.
egen v20=sum(v1) if distanceparis<=20
replace v20=0 if v20==.

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


// Market Tightness
clear
import excel using "/Users/sandrafronteau/Documents/labour/data/iris.xlsx", firstrow
rename INSEEIRISbaseicactiviteresi pop1564
rename K pop1524
rename L act1564
rename M act1524
rename N chom1564
rename O chom1524
rename NOM_COM city
drop wkt_geom

gen departement = substr(DEPCOM, 1,2)
keep if departement=="75" | departement=="95" | departement=="94" | departement=="93" | departement=="92" | departement=="91" | departement=="78" | departement=="77"
count

save "iris.dta", replace


