*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Key Individual Variable Cleaning 
*recode those don't know, refused into missing
*keep inapplicable and proxy
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 clear
 set more off
 
 global onedrive "C:\Users\Muzhi\OneDrive - Nexus365\Academia\Data\UKHLS_do\Stata_public"
 //change to your own directory where you saved your do files
 
 do "$onedrive/do/ukhls_00dir"
 capture log close
 
	
use "$WorkData\ukhls0_dataexplore_pooled.dta", clear

*---------------------------------------------*
*A. Basic Demographic Info:
*------------------------------------------*
*Sex:	
	ta x_sex
	recode x_sex -9=. 1=0 2=1, gen(sex)
	la def nsex 0 "male" 1 "female"	
	la val sex nsex
	la var sex "new:sex"
	ta x_sex sex,m
	ta sex //46% male
	
drop x_sex	
	
*Age:	
    replace age_dv=. if age_dv<0
	rename age_dv age	
	sum age //15 to 104
	la var age "new:age" //5 to 104
	count if age<16 //should be adult interviews?	
	
*Marital:
	ta wave new_mastat,row nof m
    drop mastat_dv mastat
	
	
*Age of youngest child in HH
    sum hh_agechy_dv
    recode hh_agechy_dv -9/-1=., gen(chagemin)
	sum chagemin //0-15 yrs old   
 
*Number of children:
	count if hh_nkids_dv~=nchild_dv
	order pidp  wave hh_nkids_dv nchild_dv
	replace hh_nkids_dv=. if hh_nkids_dv<0
	replace nchild_dv=. if nchild_dv<0
	replace nchild_dv=hh_nkids_dv if hh_nkids_dv~=.&nchild_dv==.
	
	rename nchild_dv nchild
drop hh_nkids_dv
	
*Education
	*ta wave qfedhi, mi
	*ta wave qfhigh_dv,mi
	*ta qfedhi, mi
	
	recode hiqual_dv -9/-1=.
	ta wave hiqual_dv,m row nof
	
	bysort pidp (wave): replace hiqual_dv=hiqual_dv[_n-1] if hiqual_dv==.&hiqual_dv[_n-1]~=.
	//0 changes made	
	
	recode hiqual_dv 1=4 2/3=3 4=2 9=1 5=5 .=5, gen(new_highedu)
	la var new_highedu "new:high edu qualific 5C"
	la def educ4  4 "1st degree+" 3 "Alevel/other higher" 2 "gcse or equal" ///
				  1 "no qualif" 5 "Other/missing"
	la val new_highedu educ4
	ta hiqual_dv new_highedu,m
	*ta wave new_highedu, row nof
	
	
	recode new_highedu 1/2=1 3=2 4=3 5=1, gen(edu3c)
	la var edu3c "new:education qualif -3C"
	la def edu3c  3 "1st degree+" 2 "other higher" 1 "<=gcse/others"
	la val edu3c edu3c
	ta hiqual_dv edu3c,m
	*ta wave edu3c, row nof //lower two levels are not quite consistent across waves
drop qfhigh_dv  qfhigh
	
*Race: white, black, asian
	/*
	ta wave race,m //wave 1-12
	ta wave racel_bh,m //wave 13-18
	ta wave racel_dv,m //wave 21-26	
	ta wave racel,m //wave 19-26
    ta x_racel_dv x_racel_bh
	*/
	
	la def race4c 0 "white" 1 "black" 2 "asian" 3 "others"
		
	recode x_racel_dv -9/-1=. 1/4=0 5/8=3 9/13=2 14/16=1 17=3 97=3, gen(racex)
	la val racex race4c
	ta x_racel_dv racex	
	ta racex,m
	
drop racel racel_dv x_race_bh 
	rename racex x_race
	la var x_race "new: 4-cate race"
	
*Religion: - will fill in when rechecking which variables in which wave
	ta wave oprlg,m
	recode oprlg -9/-1=. 1=1 2=0, gen(religion_dum)
	la var religion_dum "new: 1- has religion"
	ta wave if religion_dum==.
	
	bysort pidp (wave): replace  religion_dum=religion_dum[_n-1] if religion_dum==.
	gsort pidp -wave 
	bysort pidp: replace  religion_dum=religion_dum[_n-1] if religion_dum==.
	ta religion_dum,m
drop oprlg*

	
*Health
	gen new_hlstat=.
    la var new_hlstat "self-rated health"
	
	replace new_hlstat=1 if sf1==1&new_hlstat==.
	replace new_hlstat=2 if sf1==2&new_hlstat==.
	replace new_hlstat=3 if sf1==3&new_hlstat==.
	replace new_hlstat=4 if sf1==4&new_hlstat==.
	replace new_hlstat=5 if sf1==5&new_hlstat==.
	
	replace new_hlstat=1 if scsf1==1&new_hlstat==.
	replace new_hlstat=2 if scsf1==2&new_hlstat==.
	replace new_hlstat=3 if scsf1==3&new_hlstat==.
	replace new_hlstat=4 if scsf1==4&new_hlstat==.
	replace new_hlstat=5 if scsf1==5&new_hlstat==.
	
	
	la val new_hlstat a_sf1
	*ta hlstat new_hlstat, mi
	*ta wave new_hlstat , m
	ta wave new_hlstat, row
	
    drop sf1 scsf1


*--------------------------------------*	
*B. Other Key Variables:
*--------------------------------------*
*Gender Attitudes: 	scopfama, mb,md,mf,mh ONLY in Understanding Society!
  
	*codebook scopfama scopfamb scopfamd scopfamf scopfamh
	*1. preschool child suffers if mother works, 5-strongly disagree
	recode scopfama -9/-1=. // Higher score, more liberal:
	
	*2. family suffers if mother works fulltime - 5-strongly disagree
	recode scopfamb -9/-1=.
	
	*3. husband and wife should contribute to household income - 5 -strongly disagree
	recode scopfamd -9/-1=.
	recode scopfamd 5=1 4=2 3=3 2=4 1=5, gen(scopfamd_reversed)
	
	*4. husband should earn, wife should stay at home - 5 - strongly disagree
	recode scopfamf -9/-1=.
	
	*5. employers should help mothers combine jobs and childcare - 5 - strongly disagree
	recode scopfamh -9/-1=.
	
	gen gender_liberal4f=scopfama+scopfamb+scopfamd_reversed+scopfamf
	gen gender_liberal3f=scopfama+scopfamb+scopfamf //without liberal measures
	
	la var gender_liberal4f "new:scopfama+scopfamb+scopfamd(rev)+scopfamf"
	la var gender_liberal3f "new:scopfama+scopfamb+scopfamf"
	
	*table wave, c(mean  gender_liberal4f mean  gender_liberal3f)

*drop scopfam* //reserved for later factor analysis
	
*Employment	
/*
	codebook jbhas
	recode jbhas -9=. -2/-1=.
	recode jboff -9=. -2/-1=.
	ta jbhas jboff,mi
	gen working=[jbhas==1]
	replace working=1 if jboff==1	
	replace working=. if jbhas==.
	la var working "whether has jobs"
	ta jbhas working, mi
	*/

	ta wave jbstat
	
	replace jbhas=. if jbhas<0
	la list a_jbstat
	recode jbstat -9/-1=. 1=1 2=0 3=2 4=5 5=3 6=4 7/9=5 10=0 11/97=5, gen(jbstat_new)
	la def jbstat5c 0 "work(unpaid in)" 1 "self-emp" 2 "unemp/other" 3 "matern" 4 "fam care" 5 "retired/Others"
	la val jbstat_new jbstat5c 
	ta jbstat jbstat_new
	
	gen employed=[jbhas==1|jboff==1] //either worked last week or not worked but has job
	replace employed=. if jbhas<0|jbhas==.
	replace employed=. if employed==0&jboff<0
	replace employed=0 if employed==.&jboff==2|employed==.&jboff==3
	replace employed=1 if employed==.&jboff==1
	ta employed jboff,m
	la var employed "new: whether has a job(either worked last week or not)"	
	
	ta jbstat employed, mi 

	ta wave jbft_dv,m //it is a derived variable, calculated based on working hours
		
	recode jbft -9=. -8=3 -7=., gen(new_jbft)
	la def new_jbft  1 "FT:30hr+" 2 "PT<30hr" 3 "NotWorking"
	la val new_jbft new_jbft
	ta new_jbft employed,m
	
	replace new_jbft=3 if new_jbft==.&employed==0
	
	ta jbft new_jbft, mi //proxy has information in employed but not in jbft
	
	ta new_jbft employed if ivfio==1, mi
	ta jbstat new_jbft,m
	replace new_jbft=3 if new_jbft==.&jbstat>2&jbstat~=.
	order pidp wave employed jbstat jbhrs jshrs jbot jbft new_jbft
	ta new_jbft if ivfio==1,m
	
*Work Hours:
		*codebook jbhrs  jshrs
		*ta jbhrs
		*table wave, c(min jbhrs max jbhrs mean jbhrs)
		recode jbhrs -9/-1=. 97/100=97
		*ta jshrs
		recode jshrs  -9/-1=. 97/100=97
		*ta jbot
		recode jbot -9/-1=.
			
		gen workhrall=jbhrs+jbot
		replace workhrall=jshrs if workhr==.
		replace workhrall=97 if workhr>97&workhr~=.
		la var workhrall "working hours=normal+overtime per week[0to97]"
		table new_jbft, c(min jbhrs max jbhrs mean jbhrs)
		table new_jbft, c(min workhrall max workhrall mean workhrall)
		table jbft, c(min workhrall max workhrall mean workhrall)
		
		replace new_jbft=1 if new_jbft~=1&workhrall>29.5&workhrall~=.
		replace new_jbft=2 if new_jbft~=2&workhrall>-0.1&workhrall<30
		ta new_jbft jbft,m
		
		
drop  jbhrs  jshrs //the more ot you did, the less happy you are?
	
/*
 *Job Status - whether private company:
	ta jbsect
	recode jbsect -9/-1=.
*/
		
*Income
	order pidp pid wave fimn* hh_fi*
	sum fimnnet_dv 
    //total net personal income monthly
	sum fimnlabgrs_dv 
    //labor income: last month
	sum fimngrs_dv 
    //total income: last month
	sum hh_fihhmnnet1_dv 
    //total household net income-no deductions
	*hist fimnnet_dv
	*hist fimnlabgrs_dv
	
	recode fimnnet_dv -9/-1=. 0=0.5 /*50000/687500=50000*/
	count if fimnnet_dv<0 //261
	
	*hist lnfimnnet
	*list pidp wave lnfimnnet if lnfimnnet<0 //many 0.5 cases, no labour income
	*hist fimnnet_dv
	
	recode fimnlabgrs_dv -9/-1=. 0=0.5 /*50000/16666=50000*/
	count if fimnlabgrs_dv<0	//510
	
	recode fimngrs_dv -9/-1=. 0=0.5 /*50000/27916.33=50000*/
	count if fimngrs_dv<0 //261
	
	/*
	table wave, c(median hh_fihhmnnet1_dv) //ONLY in UnSoc
	table wave, c(median hh_fihhyr) //ONLY in BHPS - Annual
	table wave, c(median fihhmn) //household income: month before interview only BHPS
	table wave, c(median hh_fihhmngrs_dv) //ONLY in UnSoc
	*/	
	
	gen fihhmn_all=hh_fihhmnnet1_dv
	la var fihhmn_all "new: monthly HOUSEHOLD income[net]"
	*table wave, c(median fihhmn_all)
	
	recode fihhmn_all -9/-1=. 0=0.5
	count if fihhmn_all<0 //139 cases
		
	gen year=doiy
	merge n:1 year using ///
	"$onedrive/UK1989_2019CPI" 
	//this data is from UK ONS:https://www.ons.gov.uk/economy/inflationandpriceindices/timeseries/d7g7/mm23
	//updated till year 2018, 2015 is set as 1: inflation=1+CPI*0.001
	sum year //1989 to 2018
	sum doiy //1991 to 2018
	
	keep if _merge==3
	drop _merge year *2015	
  
 *Individual Income:
    gen fimngrs15=fimngrs_dv/inflationratio
	la var fimngrs15 "new: Individual total income(last month)adj 2015"
      
    gen fimnlabgrs15=fimnlabgrs_dv/inflationratio
    la var fimnlabgrs15 "new: Individual last month gross LABOR income adj2015"
    
    gen fimnnet15=fimnnet_dv/inflationratio 
	la var fimnnet15 "new: Individual monthly NET personal income adj2015" 
    
  *Household Income:
    gen fihhmn_all15=fihhmn_all/inflationratio
	la var fihhmn_all15  "new: monthly HOUSEHOLD income[net]adj 2015"
    
*Logged Income:
	gen lnfimngrs15=ln(fimngrs_dv/inflationratio)
	la var lnfimngrs15 "new: Logged Individual last month gross TOTAL income adj2015"
	
    gen lnfimnlabgrs15=ln(fimnlabgrs_dv/inflationratio)
	la var lnfimnlabgrs15 "new: Logged Individual last month gross LABOR income adj2015"
	
	gen lnfimnnet15=ln(fimnnet_dv/inflationratio) if fimnnet_dv>0
	la var lnfimnnet15 "new: Logged Individual monthly NET personal income adj2015" 
	sum lnfimnnet //UnSoc ONLY
	
	gen lnfihhmn15=ln(fihhmn_all/inflationratio)
	la var lnfihhmn15 "new: Logged monthly HOUSEHOLD income[net] adj2015"
	
	
*Housework time:
	ta wave if howlng<0
	replace howlng=. if howlng<0
	table wave, c(min howlng max howlng mean howlng)
	sum howlng
	*hist howlng if sex==0
	*hist howlng if sex==1
	replace howlng=97 if howlng>97&howlng~=.
	*hist howlng 
	

*Region
    ta gor_dv
	*ta wave region,m //not in UnSoc
	recode gor_dv -9/-1=. 1/9=1 10=2 11=3 12=4, gen(country) //1 - england; 2 - walse; 3 - scotland; 4 - northern ireland	
	la def country 1 "England" 2 "Wales" 3 "Scotland" 4 "Northern Ireland/Islands"
	la val country country
	la var country "new: England, Wales, Scotland, NI"
	
	ta gor_dv country, m 
	drop hh_gor_dv 
	

*Weight - already did in ukhls0_Explore do file
	order pidp pid wave strata x_strata psu x_psu
	replace x_strata=strata if strata~=.&x_strata==.
	replace x_psu=psu if psu~=.&x_psu==.
	*order pidp pid wave hh_xhweight lrwght indinus_xw
	*ta wave if hh_xhweight==.
	*ta wave if hh_xhweight==0	
	
drop strata psu
		
drop scopecl* scopngb* 


save "$WorkData\ukhls3_pooled",replace


erase "$WorkData/ukhls_hhrespch.dta"
erase "$WorkData/ukhls_indresp.dta"
erase "$WorkData/ukhls_xwavedat.dta"

erase "$WorkData/ukhls0_dataexplore_pooled.dta"



*=============================
*Delete those numbered data files
*=============================

forval i=3/9{
erase "$WorkData/`i'_indsamp.dta"
erase "$WorkData/`i'_newborn.dta"
erase "$WorkData/`i'_parstyle.dta"
erase "$WorkData/`i'_callrec.dta"
erase "$WorkData/`i'_child.dta"
erase "$WorkData/`i'_egoalt.dta"
erase "$WorkData/`i'_hhresp.dta"
erase "$WorkData/`i'_hhsamp.dta"
erase "$WorkData/`i'_income.dta"
erase "$WorkData/`i'_indall.dta"
erase "$WorkData/`i'_indresp.dta"
erase "$WorkData/`i'_youth.dta"
}
**


forval i=1/2{
 erase "$WorkData/`i'_callrec.dta"
erase "$WorkData/`i'_child.dta"
erase "$WorkData/`i'_egoalt.dta"
erase "$WorkData/`i'_hhresp.dta"
erase "$WorkData/`i'_hhsamp.dta"
erase "$WorkData/`i'_income.dta"
erase "$WorkData/`i'_indall.dta"
erase "$WorkData/`i'_indresp.dta"
erase "$WorkData/`i'_youth.dta"   
}

foreach i in 1 6{
erase "$WorkData/`i'_adopt.dta"
erase "$WorkData/`i'_cohab.dta"
erase "$WorkData/`i'_marriage.dta"
erase "$WorkData/`i'_natchild.dta"
}
**

foreach i in 3 5 7 9{
erase "$WorkData/`i'_chmain.dta"
}
**

erase "$WorkData/1_empstat.dta"
erase "$WorkData/1_issue.dta"
erase "$WorkData/2_indsamp.dta"
erase "$WorkData/2_newborn.dta"