// Intro
clear
set memory 1000m
cd "C:\Users\Alex\Documents\EPP M2\LaborWasmer\Reg"

use "Job_Offers_Ile-de-France.dta"
*insheet excel  "Coordonnées + Data IRIS.xlsx"

// Nettoyage 
decode city, generate(city2)
drop city
rename city2 city
drop if city=="0"
drop if longitude==0
drop if latitude==0
drop if longitude==.
drop if latitude==.
drop date
drop Description_


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

