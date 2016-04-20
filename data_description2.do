clear
capture log using "/Users/sandrafronteau/Documents/labour/results/$S_DATE $S_TIME.log", replace
*set mem 700m if earlier version of stata (<stata 12)
set more off

cd "/Users/sandrafronteau/Documents/labour/"

clear
import excel using "Job_Offers_Ile-de-France_Complete2.xlsx", firstrow
drop date
drop Description
drop K
order city
sort city-Jobtype

save "Job_Offers_Ile-de-France_Complete2.dta", replace

global jobtype= "CDI CDD Alternance Stage Interim Independant"
foreach i of global jobtype{
	bysort longitude : gen nb`i'=1 if Jobtype=="`i'"
		replace nb`i'=0 if nb`i'==.
			by longitude: egen totalnb`i' = sum(nb`i')
				drop nb`i'
}

*TOTAL NB OF JOBS PER SECTOR BY LONGITUDE

set more off
global sector= "Achat Agriculture Alimentation Architecture Assurance Banque Btp Commerce_Vente Comptabilite Culture Distribution Droit Enseignement Environnement_Amenagement Finance Immobilier Industrie Informatique Ingenierie Mecanique Medias_Edition"

foreach j of global sector{
	bysort longitude : gen nb`j'=1 if Sector=="`j'"
		replace nb`j'=0 if nb`j'==.
			by longitude: egen totalnb`j' = sum(nb`j')
				drop nb`j'
}

global sector2= "Marketing_Communication Physique_Chimie RH_Gestion Sante Secretariat_Administratif Service_clientele Securite Social_Service Telecommunications Tourisme_Hotellerie Transports_Logistique"

foreach j of global sector2{
	bysort longitude : gen nb`j'=1 if Sector=="`j'"
		replace nb`j'=0 if nb`j'==.
			by longitude: egen totalnb`j' = sum(nb`j')
				drop nb`j'
}

sort city-totalnbTransports_Logistique

export excel using "sector_jobtype_bylongitude2.xlsx", firstrow(variables)



set more on
log close
