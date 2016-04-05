// Intro
clear
set memory 1000m
cd "C:\Users\Alex\Documents\EPP M2\LaborWasmer\Reg"

use "Job_Offers_Ile-de-France.dta"
insheet excel  "Coordonnées + Data IRIS.xlsx"

browse

// Gen variables en grad

generate latgrad = latitude*3.1415/180
generate longrad = longitude*3.1415/180

// Nettoyage 

drop if longitude==0
drop if latitude==0
drop if latitude==.
drop if latitude==.
count
browse




// Distance des offres par rapport à Paris
count if sqrt((0.8529244-latgrad)^2+(0.0406976-longrad)^2)*6371 < 6

gen distanceparis = sqrt((0.8529244-latgrad)^2+(0.0406976-longrad)^2)*6371

** A faire - graph distance des offres par rapport à Paris
twoway scatter distanceparis
 sqrt((0.8529244-latgrad)^2+(0.0406976-longrad)^2)*6371

// Regroupement des offres 0,10 et 20km

display sqrt(((48.856-50.63)*3.14/180)^2+((2.350-3.063)*3.14/180)^2)*6371

** A faire - Nombre d'observation par ville

** A faire - Nombre d'observation à 10km, 20km  
 
help varlist 
help global

gen v=1


by city, sort : gen v2=sum(v)

count if latgrad =0.8523195

foreach i in latgrad, count if (latgrad i =latgrad)

foreach i in latgrad, sqrt((latgrad i-latgrad)^2+(longrad i-longrad)^2)*6371 < 10



generate V0 = count if (latgrad_n=latgrad)

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



// Market Tightness
