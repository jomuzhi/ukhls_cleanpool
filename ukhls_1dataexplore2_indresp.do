****************************************
*Step 2: Personal Information from Each Wave

*Alternating 1. gender attitudes; 2. fertility expectations; 3. housework time in different waves


**********************************
*Wave 1 to X from Understanding Society
*Income&Financial - Gross and Net Personal Income; Gross and Net Labor Income
**********************************
global ind "ivfio pid pidp sppid ppid hid doiy agedv istrtdatm  strata psu" 
//Add your own variable of Interest
global indodd "scop* "

use "$WorkData\1_indresp.dta", clear 
	gen wave=1    
    rename *_# *n#
    rename *_*_* *_**
    
    rename *_* .*
    
	rename istrtdaty  doiy
	ta doiy
	*ta jbterm1 //permanant; seasonal; fixed contract
	*rename hlsf1  hlstat
	*la list a_jbstat
	
	sum sppid if mastatdv==10
	sum ppid if mastatdv==10
	
	*Education:
		ta qfhighdv //too many with none of the above answers!
		ta qfhigh		
			
		order pidp sppid ppid livesp livewith 
        keep wave $ind howlng  oprlg racel 
        
	sort pidp wave
	order pidp wave
    rename *dv *_dv
    rename *if *_if
    rename *xw *_xw
save "$WorkData\indresp_basic1.dta", replace


//evenwaves: gender attitudes, housework, pregp, and longitudinal weight
//wave 8 not asked gender attitudes
forval i=2(2)6{
use "$WorkData/`i'_indresp.dta", clear 
	gen wave=`i'   
    rename *_# *n#
    rename *_*_* *_**
    
    rename *_* .*
    
	rename istrtdaty  doiy
	
	ta doiy
	
	*rename hlsf1  hlstat
	*la list b_jbstat
			
    keep wave $ind howlng  scop*  *xw *lw preg scsf1
	
	sort pidp wave
	order pidp wave		
    
    rename *dv *_dv
    rename *lw *_lw
    rename *xw *_xw
    rename *if *_if
    
save "$WorkData/indresp_basic`i'.dta", replace
}
**

*Wave 8 - no gender attitudes info
use "$WorkData/8_indresp.dta", clear 
gen wave=8  
    rename *_# *n#
    rename *_*_* *_**
    
    rename *_* .*
    
	rename istrtdaty  doiy
	
	ta doiy
	
	*rename hlsf1  hlstat
	*la list b_jbstat
			
    keep wave $ind howlng  *xw *lw preg scsf1
	
	sort pidp wave
	order pidp wave		
    
    rename *dv *_dv
    rename *lw *_lw
    rename *xw *_xw
    rename *if *_if
    
save "$WorkData/indresp_basic8.dta", replace

*No housework time info
forval i=3(2)9 {
use "$WorkData/`i'_indresp.dta", clear 
	gen wave=`i'   
    rename *_# *n#
    rename *_*_* *_**
    
    rename *_* .*
    
	rename istrtdaty  doiy
	
	ta doiy
	
	*rename hlsf1  hlstat
	*la list b_jbstat
			
    keep wave $ind  *xw *lw preg scsf1
	
	sort pidp wave
	order pidp wave		
    
    rename *dv *_dv
    rename *lw *_lw
    rename *xw *_xw
    rename *if *_if
    
save "$WorkData/indresp_basic`i'.dta", replace
}


*--------------------------Append------------------------------*

use "$WorkData\indresp_basic1.dta", clear //w1
forval i=2/9{
	 append using "$WorkData\indresp_basic`i'.dta" //w2
     }
    **
	
 forval i=1/9{
	erase "$WorkData\indresp_basic`i'.dta"
    }
    **



