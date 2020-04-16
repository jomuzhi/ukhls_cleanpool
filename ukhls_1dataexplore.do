*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
*Data Append - Pool waves of data into one file
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
 clear
 set more off
 
 global onedrive "C:\Users\Muzhi\OneDrive - Nexus365\Academia\Data\UKHLS_do\Stata_public"
 //change to your own directory where you saved your do files
 
 do "$onedrive/do/ukhls_00dir"
 capture log close


******************************************
*A: Individual Fixed Data: Basic Sample Info, Sex, Age, Education, Ethnicity, 1st Job
******************************************
use "$RawData\ukhls_wx\xwavedat", clear  //from special licenced data!
	count //147,087 individuals
	
 *Sex Harmonization:
	replace sex_dv=. if sex_dv<0
	replace sex=. if sex<0
	replace sex_dv=sex if sex_dv==.
	drop sex
    ta sex_dv,m
    
    rename sex_dv sex

#delimit ;	
	keep pidp pid xwdat_dv hhorig hhorig memorig         psu strata sampst psmwave
		 sex 
		 evermar_dv  lvag16 agelh
		 ch1by_dv anychild_dv bornuk_dv
		 hhorig_bh ethn_dv racel_dv race_bh 
   ;
   
#delimit cr
	
	rename * x_*
	rename x_pidp pidp
	rename x_pid pid	
	
	/*ta x_anychild_dv x_lprnt*/

	count if pidp==.
	

	replace pid=. if pid<0
	replace pidp=. if pidp<0
  	
	ta x_xwdat_dv if pid~=. 
	ta x_xwdat_dv if pid==.
	
 la data "Fixed personal Info from BHPS and UnSoc"
 note: Jan 2020 Muzhi ZHOU UKHLS
save "$WorkData\ukhls_xwavedat.dta",replace 


************************************************
*B: Append Household-level Information from Each Wave
************************************************
clear 
set more off
	do "$onedrive/do/ukhls_1dataexplore1_hhresp"
	ta wave if hid==. //hid only during w1-18
	ta wave if hidp==. //new household from UnSoc, 
	
	gen double new_hid=hid
	replace new_hid=hidp if hid==.
	count if new_hid==.
	la var new_hid "Household Identifier(BHPS&UnSoc)"
	format new_hid %12.0f
	*duplicates report new_hid wave
	
	order new_hid hid hidp wave
	rename * hh_*
	rename hh_new_hid new_hid
	rename hh_wave wave
	
*Household weight - cross -sectional:
 * UnSoc - weight
    gen hh_xhweight=.
    la var hh_xhweight "cross sectional household weight"
	replace hh_xhweight=hh_hhdenus_xw if wave==1 //wave 1 UnSoc cross-sectional
	replace hh_xhweight=hh_hhdenub_xw if wave>1
	order new_hid hh_hid hh_hidp wave hh_xhweight hh_hhdenus_xw 
	table wave, c(mean hh_xhweight) 
	
	drop hh_hhdenus_xw  ///
		 hh_hhdenbh_xw hh_hhdenub_xw hh_hhdenui_xw

save "$WorkData\ukhls_hhrespch.dta", replace	



	
		
*******************************************
*D: Individual Information from Each Wave
*******************************************
clear 
set more off
	do "$onedrive/do/ukhls_1dataexplore2_indresp"
	ta wave,m
    egen wavemax=max(wave)
	global wavemax "wavemax"
    
*Individual x-sectional Weight:
	gen xweight=indinus_xw if wave==1 
    //wave 1 only pure x-sectional adult main interview
	replace xweight=indinub_xw if wave>1&wave<6 
    //UnSoc wave 1-5
	replace xweight=indinui_xw if wave>5 
    //further include ECHP in wave 6
    
	order pidp pid wave xweight 
	ta wave if xweight==. //
	ta gor_dv if xweight==.	
	ta wave if xweight==0 
	la var xweight "new:x-sect weight UK Level" 
    //main respondent for x-sectional analysis
	
	drop *_xw 
	
*Whether observed in next wave:
	gen snxt=0
		forval i=1/9{
		bysort pidp (wave): replace snxt=1 if wave==`i'&wave[_n+1]==`i'+1
		}
		**
		order pidp wave snxt 
		la var snxt "new: individual have observation at time t+1"
		replace snxt=. if wave==$wavemax //last wave
			
save "$WorkData\ukhls_indresp.dta", replace

	 
use "$WorkData\ukhls_indresp.dta", clear

*After Appending - BHPS and UnSoc 	 
	replace pid=. if pid<0
	sort pidp wave
	order pidp pid wave
	*duplicates report pid wave if pid~=.	
	*duplicates report pidp wave //no duplicates!
	count if hidp==. //this one having missing cases
	ta wave if hidp==. //only in waves 1-18

	
*New household ID - combine BHPS and UnSoc:
	gen double new_hid=hid
	replace new_hid=hidp if new_hid==.
	format new_hid %-12.0f
	count if new_hid==.
    drop hidp
		
 *Year of Interview
	order pidp wave doiy istrtdatm
	rename istrtdatm doim
	ta doiy,m 
    //some cases are missing or inapplicable?
	replace doiy=. if doiy<0
	replace doim=. if doim<0
	ta wave if doiy==. //almost all missing in wave 19
    ta wave if doim==.
   	
	
 *New ID and Spouse ID: follow pid if having pid, using us_pid if no pid(BHPS)
	/*
	//No need for getting new_pid because already pidp serves this purpose
	gen double new_pid=pid if pid>0&pid~=.
	replace new_pid=pidp if new_pid==.&pidp>0&pidp~=.
	format new_pid %-12.0f
	order new_pid
	count if new_pid==.
	
	sort new_pid wave
	la var new_pid "BHPS pid&USoc pidp if no pid"
	*duplicates report new_pid wave //clear
	*/
	
*Harmonize marital status:
*ta wave  mastat
	*ta mastat_dv
	ta wave if mastat_dv~=. //only after wave19
	ta wave if mastat==. //missing in all wave19 and after
	
	la list a_mastat_dv
    
	recode mastat_dv -9/-1=. 0=. 1=0 2=2 3=. 4=3 5=3 6=4 7=3 8=3 9=4 10=1, into(new_mastat)
	la def mastatnew 0 "never married" 1 "living as couple" 2 "married" 3 "sep/div" 4 "widowed"
	la val new_mastat mastatnew
	*ta mastat_dv new_mastat,mi
	
	*la list ba_mastat
	replace new_mastat=. if mastat>-10&mastat<1|mastat>6&mastat<11
	replace new_mastat=2 if mastat==1
	replace new_mastat=1 if mastat==2
	replace new_mastat=4 if mastat==3
	replace new_mastat=3 if mastat==4|mastat==5
	replace new_mastat=0 if mastat==6
	
	*ta mastat new_mastat,m
	la var new_mastat "new:harmonized marital status simple"
	*ta wave new_mastat,m
	*ta wave new_mastat,row	
	
save, replace

	 
******************************************
*Merge Pooled panel individual detailed info with other data
*******************************************
	use "$WorkData\ukhls_indresp.dta", clear
	
 *1. merge with personal fixed info data [household info data-merge later using weight do files]
	 merge n:1 pidp using "$WorkData\ukhls_xwavedat.dta"
	 ta x_xwdat_dv _merge,m
	 drop if x_xwdat_dv==.
	 
	 keep if _merge==3 //keep adults merging
     //those not matched from using(xwave) can be children and youths
     
	 drop _merge
	
 *2. merge with household level data (about # of children aged 0-11, nchild in individual record):
	 merge n:1 new_hid wave using "$WorkData\ukhls_hhrespch.dta"
	 order pidp new_hid hh_nkids_dv _merge
	 //1,626 not matched with master household data, not in household level data
	 //745 not matched with using data
	 
	 drop if _merge==2 
     //also keep those with no household level info
	
	 rename _merge hh_merge		
	
sort pidp pid wave
order pidp pid wave doiy doim
	
la data "UKHLS Wave 1 to wave 9 key personal info"
note: 2020 Muzhi ZHOU UK UKHLS
save "$WorkData\ukhls0_dataexplore_pooled.dta", replace  	

*Internet use:
recode netuse -9/-1=. 3/6=6, gen(netuse_new)
la val netuse_new a_netuse

ta wave netuse_new,m row

*erase "$WorkData/ukhls_hhrespch.dta"
*erase "$WorkData/ukhls_indresp.dta"
	
