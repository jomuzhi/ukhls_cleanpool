*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
*Data Rename
//rename files to have consistent names for later analysis
//all saved as workdata
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
 clear
 set more off

 do "C:\Users\muzhi\OneDrive - HKUST\OD-Ox\Academia\DataDo\UKHLS_do\Stata_2023/ukhls_00dir"
 capture log close 
 log using "$Output\log_ukhls0rename", replace //log file
 
 
  global lastwave "30" //change here the last wave you've renamed
  
*=================================================BHPS rename===================================
*1. each wave all has the same files
  
  set obs 1
 
  gen str2 ba = "ba"
  gen str2 bb = "bb"
  gen str2 bc = "bc"
  gen str2 bd = "bd"
  gen str2 be = "be"
  gen str2 bf = "bf"
  gen str2 bg = "bg"
  gen str2 bh = "bh"
  gen str2 bi = "bi"
  gen str2 bj = "bj"
  gen str2 bk = "bk"
  gen str2 bl = "bl"
  gen str2 bm = "bm"
  gen str2 bn = "bn"
  gen str2 bo = "bo"
  gen str2 bp = "bp"
  gen str2 bq = "bq"
  gen str2 br = "br"
  gen str2 bs = "bs"  
  

 global name "a b c d e f g h i j k l m n o p q r s t"
 global bname "ba bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
 
 gen wave=0
foreach var in $bname {
	replace wave=1 if `var'== "ba"
	replace wave=2 if `var'== "bb"
	replace wave=3 if `var'== "bc"
	replace wave=4 if `var'== "bd"
	replace wave=5 if `var'== "be"
	replace wave=6 if `var'== "bf"
	replace wave=7 if `var'== "bg"
	replace wave=8 if `var'== "bh"
	replace wave=9 if `var'== "bi"
	replace wave=10 if `var'== "bj"
	replace wave=11 if `var'== "bk"
	replace wave=12 if `var'== "bl"
	replace wave=13 if `var'== "bm"
	replace wave=14 if `var'== "bn"
	replace wave=15 if `var'== "bo"
	replace wave=16 if `var'== "bp"
	replace wave=17 if `var'== "bq"
	replace wave=18 if `var'== "br"
	
	local waven=wave
	
	use "$RawDataBHPS/`var'_egoalt.dta", clear  
	save "$WorkData/raw_renamed/`waven'_egoalt.dta", replace
	
	use "$RawDataBHPS/`var'_hhresp.dta", clear  
	save "$WorkData/raw_renamed/`waven'_hhresp.dta", replace
	
	use "$RawDataBHPS/`var'_hhsamp.dta", clear  
	save "$WorkData/raw_renamed/`waven'_hhsamp.dta", replace
	
	use "$RawDataBHPS/`var'_income.dta", clear  
	save "$WorkData/raw_renamed/`waven'_income.dta", replace
	
	use "$RawDataBHPS/`var'_indall.dta", clear  
	save "$WorkData/raw_renamed/`waven'_indall.dta", replace
	
	use "$RawDataBHPS/`var'_indresp.dta", clear 
	save "$WorkData/raw_renamed/`waven'_indresp.dta", replace
	
	use "$RawDataBHPS/`var'_jobhist.dta", clear  
	save "$WorkData/raw_renamed/`waven'_jobhist.dta", replace
	        
	clear
    
  set obs 1
  gen str2 ba = "ba"
  gen str2 bb = "bb"
  gen str2 bc = "bc"
  gen str2 bd = "bd"
  gen str2 be = "be"
  gen str2 bf = "bf"
  gen str2 bg = "bg"
  gen str2 bh = "bh"
  gen str2 bi = "bi"
  gen str2 bj = "bj"
  gen str2 bk = "bk"
  gen str2 bl = "bl"
  gen str2 bm = "bm"
  gen str2 bn = "bn"
  gen str2 bo = "bo"
  gen str2 bp = "bp"
  gen str2 bq = "bq"
  gen str2 br = "br"
  gen str2 bs = "bs"  
 
 global bname "ba bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
 
 gen wave=0
	
}
**

*2. From wave 2 - start to have the same files

set more off
 global bname "ba bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
 

 global bname "bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
foreach var in $bname {
	replace wave=2 if `var'== "bb"
	replace wave=3 if `var'== "bc"
	replace wave=4 if `var'== "bd"
	replace wave=5 if `var'== "be"
	replace wave=6 if `var'== "bf"
	replace wave=7 if `var'== "bg"
	replace wave=8 if `var'== "bh"
	replace wave=9 if `var'== "bi"
	replace wave=10 if `var'== "bj"
	replace wave=11 if `var'== "bk"
	replace wave=12 if `var'== "bl"
	replace wave=13 if `var'== "bm"
	replace wave=14 if `var'== "bn"
	replace wave=15 if `var'== "bo"
	replace wave=16 if `var'== "bp"
	replace wave=17 if `var'== "bq"
	replace wave=18 if `var'== "br"
	
	local waven=wave
	//youth are from wave 4
	/*
	//from wave 16
	use "$RawData/bhps_w`waven'/`var'_jobhstd.dta", clear  
	save "$WorkData/`waven'_jobhstd.dta", replace
	*/
	//indsamp from wave 2
	use "$RawDataBHPS/`var'_indsamp.dta", clear  
	save "$WorkData/raw_renamed/`waven'_indsamp.dta", replace
	/*
	//wave 2,11, 12 further has cohabit, childad, childnt, marriag, lifemst
	//child
	*/
	clear
  set obs 1
 
  gen str2 bb = "bb"
  gen str2 bc = "bc"
  gen str2 bd = "bd"
  gen str2 be = "be"
  gen str2 bf = "bf"
  gen str2 bg = "bg"
  gen str2 bh = "bh"
  gen str2 bi = "bi"
  gen str2 bj = "bj"
  gen str2 bk = "bk"
  gen str2 bl = "bl"
  gen str2 bm = "bm"
  gen str2 bn = "bn"
  gen str2 bo = "bo"
  gen str2 bp = "bp"
  gen str2 bq = "bq"
  gen str2 br = "br"
  gen str2 bs = "bs"  
  
 global bname "bb bc bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
 
 gen wave=0
	
}

*
*3. From wave 4 - start to have youth files
set more off
 global bname "bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
foreach var in $bname {
	replace wave=4 if `var'== "bd"
	replace wave=5 if `var'== "be"
	replace wave=6 if `var'== "bf"
	replace wave=7 if `var'== "bg"
	replace wave=8 if `var'== "bh"
	replace wave=9 if `var'== "bi"
	replace wave=10 if `var'== "bj"
	replace wave=11 if `var'== "bk"
	replace wave=12 if `var'== "bl"
	replace wave=13 if `var'== "bm"
	replace wave=14 if `var'== "bn"
	replace wave=15 if `var'== "bo"
	replace wave=16 if `var'== "bp"
	replace wave=17 if `var'== "bq"
	replace wave=18 if `var'== "br"
	
	local waven=wave
	//youth are from wave 4
	use "$RawDataBHPS/`var'_youth.dta", clear  
	save "$WorkData/raw_renamed/`waven'_youth.dta", replace

	clear
  set obs 26
 
  gen str2 bd = "bd"
  gen str2 be = "be"
  gen str2 bf = "bf"
  gen str2 bg = "bg"
  gen str2 bh = "bh"
  gen str2 bi = "bi"
  gen str2 bj = "bj"
  gen str2 bk = "bk"
  gen str2 bl = "bl"
  gen str2 bm = "bm"
  gen str2 bn = "bn"
  gen str2 bo = "bo"
  gen str2 bp = "bp"
  gen str2 bq = "bq"
  gen str2 br = "br"
  gen str2 bs = "bs"  
  
 global bname "bd be bf bg bh bi bj bk bl bm bn bo bp bq br"
 
 gen wave=0
	
}


use "$RawDataBHPS/xwaveid_bh.dta", clear  
save "$WorkData/raw_renamed/bh_xwaveid_bh.dta", replace

use "$RawDataBHPS/xwlsten.dta", clear  
save "$WorkData/raw_renamed/bh_xwlsten.dta", replace


*=========================================UnSoc Rename======================================
clear
set more off
 
*1. ukhls wave 1 and 6 has many additional files
 set obs 1
 gen str adopt= "adopt"
 gen str callrec= "callrec"
 gen str child="child"
 gen cohab="cohab"
 gen egoalt="egoalt"
 gen empstat="empstat"
 gen hhresp="hhresp"
 gen hhsamp="hhsamp"
 gen income="income"
 gen indall="indall"
 gen indresp="inderep"
 gen issue="issue"
 gen marriage="marriage"
 gen natchild="natchild"
 gen youth="youth"
 
  gen newborn="newborn"
  gen parstyle="parstyle"
  gen indsamp = "indsamp"
  gen chmain = "chmain"
 
 global filename "adopt callrec child cohab egoalt empstat hhresp hhsamp income indall indresp issue marriage natchild youth"
 /*newborn indsamp parstyle chmain*/
 
 *adopt - a and f
 *cohab - a and f
 *marriage - a and f
 *natchild - a and f
 *empstat - a and e
 *issue - a, b, c, d, e
 *chmain - c, e, g, i, k
  *newborn - from b
 *indsamp - from b
 *partsyle - from c
  *Others in all waves
 
*1. Only in a and others in a as well - completely rename all a wave
foreach var in $filename {
 use "$RawDataUnS/a_`var'.dta", clear
 save "$WorkData/raw_renamed/19_`var'.dta", replace
}
**

*2. Only in f and others will be grouped with waves from the 2nd

 global filename "adopt cohab marriage natchild"
  
  
 foreach var in $filename {
 use "$RawDataUnS/f_`var'.dta", clear
 save "$WorkData/raw_renamed/24_`var'.dta", replace
}
**

*3. Other strange ones in specific waves

 foreach var in empstat {
 use "$RawDataUnS/e_`var'.dta", clear
 save "$WorkData/raw_renamed/23_`var'.dta", replace //wave e
}

 foreach var in issue {
 use "$RawDataUnS/b_`var'.dta", clear
 save "$WorkData/raw_renamed/20_`var'.dta", replace //wave b
 use "$RawDataUnS/c_`var'.dta", clear
 save "$WorkData/raw_renamed/21_`var'.dta", replace //wave c
 use "$RawDataUnS/d_`var'.dta", clear
 save "$WorkData/raw_renamed/22_`var'.dta", replace //wave d
 use "$RawDataUnS/e_`var'.dta", clear
 save "$WorkData/raw_renamed/23_`var'.dta", replace //wave e
}

 
*4. Some files start to appear in later waves/alternating waves
gen wave=0
gen chmain="chmain" //in w3, w5, w7, w9, w11 [//need to update here when new waves added]
global name "c e g i k"
foreach var in $name{

 replace wave=3 if `var'=="c"
 
 replace wave=5 if `var'=="e"
 
 replace wave=7 if `var'=="g"
 
 replace wave=9 if `var'=="i"
 
 replace wave=11 if `var'=="k"
 
 local wn=wave
 local waven=wave+18
 
 use "$RawDataUnS/`var'_chmain", clear
 save "$WorkData/raw_renamed/`waven'_chmain", replace 
  
 clear
 set more off
  set obs 26
  gen str1 a = "a"
  gen str1 b = "b"
  gen str1 c = "c"
  gen str1 d = "d" 
  gen str1 e = "e"
  gen str1 f = "f"
  gen str1 g = "g"
  gen str1 h = "h"
  gen str1 i = "i"
  gen str1 j = "j" 
  gen str1 k = "k"
  gen str1 l = "l"
  gen str1 m = "m"
  gen str1 n = "n"
  gen str1 o = "o"
  gen str1 p = "o"
  gen str1 q = "q"
  gen str1 r = "r"
  gen str1 s = "s"
  gen str1 t = "t"
  
global name "c e g i k"

gen wave=0
 }
 **

gen parstyle="parstyle" //in w3, w4, w5, w6, w7, w8, w9, w10
capture drop wave
gen wave=0
global name "c d e f g h i j k l" //need to update here when new waves added
foreach var in $name{
 replace wave=3 if `var'=="c"
 replace wave=4 if `var'=="d"
 replace wave=5 if `var'=="e"
 replace wave=6 if `var'=="f"
 replace wave=7 if `var'=="g"
 replace wave=8 if `var'=="h"
 replace wave=9 if `var'=="i"
 replace wave=10 if `var'=="j"
 replace wave=11 if `var'=="k"
 replace wave=12 if `var'=="l"
 
 local wn=wave
 local waven=wave+18
  
 use "$RawDataUnS/`var'_parstyle", clear
 save "$WorkData/raw_renamed/`waven'_parstyle", replace
 
 clear
 set more off
  set obs 26

  gen str1 c = "c"
  gen str1 d = "d" 
  gen str1 e = "e"
  gen str1 f = "f"
  gen str1 g = "g"
  gen str1 h = "h"
  gen str1 i = "i"
  gen str1 j = "j" 
  gen str1 k = "k"
  gen str1 l = "l"
  gen str1 m = "m"
  gen str1 n = "n"
  gen str1 o = "o"
  gen str1 p = "o"
  gen str1 q = "q"
  gen str1 r = "r"
  gen str1 s = "s"
  gen str1 t = "t"
  
global name "c d e f g h i j k l" //need to update here when new waves added

gen wave=0
 }
 **

*5. Same files shared from wave 2
clear
set more off
  set obs 26
  gen str1 a = "a"
  gen str1 b = "b"
  gen str1 c = "c"
  gen str1 d = "d" 
  gen str1 e = "e"
  gen str1 f = "f"
  gen str1 g = "g"
  gen str1 h = "h"
  gen str1 i = "i"
  gen str1 j = "j" 
  gen str1 k = "k"
  gen str1 l = "l"
  gen str1 m = "m"
  gen str1 n = "n"
  gen str1 o = "o"
  gen str1 p = "o"
  gen str1 q = "q"
  gen str1 r = "r"
  gen str1 s = "s"
  gen str1 t = "t"
  
global name "b c d e f g h i j k l" //need to update here when new waves added

gen wave=0

foreach var in $name{
 replace wave=2 if `var'=="b"
 replace wave=3 if `var'=="c"
 replace wave=4 if `var'=="d"
 replace wave=5 if `var'=="e"
 replace wave=6 if `var'=="f"
 replace wave=7 if `var'=="g"
 replace wave=8 if `var'=="h"
 replace wave=9 if `var'=="i"
 replace wave=10 if `var'=="j"
 replace wave=11 if `var'=="k"
 replace wave=12 if `var'=="l"
 
 local wn=wave
 local waven=wave+18
 
 use "$RawDataUnS/`var'_callrec", clear
 save "$WorkData/raw_renamed/`waven'_callrec", replace
 
  use "$RawDataUnS/`var'_child", clear
 save "$WorkData/raw_renamed/`waven'_child", replace
 
  use "$RawDataUnS/`var'_egoalt", clear
 save "$WorkData/raw_renamed/`waven'_egoalt", replace
 
  use "$RawDataUnS/`var'_hhresp", clear
 save "$WorkData/raw_renamed/`waven'_hhresp", replace
 
  use "$RawDataUnS/`var'_hhsamp", clear
 save "$WorkData/raw_renamed/`waven'_hhsamp", replace
 
  use "$RawDataUnS/`var'_income", clear
 save "$WorkData/raw_renamed/`waven'_income", replace
 
  use "$RawDataUnS/`var'_indall", clear
 save "$WorkData/raw_renamed/`waven'_indall", replace
 
  use "$RawDataUnS/`var'_indresp", clear
 save "$WorkData/raw_renamed/`waven'_indresp", replace
 /*
  use "$RawData/ukhls_w`wn'/`var'_issue", clear
 save "$WorkData/`waven'_issue", replace
 */
  use "$RawDataUnS/`var'_youth", clear
  save "$WorkData/raw_renamed/`waven'_youth", replace
 
  use "$RawDataUnS/`var'_indsamp", clear
  save "$WorkData/raw_renamed/`waven'_indsamp", replace 
  
  use "$RawDataUnS/`var'_newborn", clear
  save "$WorkData/raw_renamed/`waven'_newborn", replace
 
 clear
 set more off
  set obs 26
  gen str1 a = "a"
  gen str1 b = "b"
  gen str1 c = "c"
  gen str1 d = "d" 
  gen str1 e = "e"
  gen str1 f = "f"
  gen str1 g = "g"
  gen str1 h = "h"
  gen str1 i = "i"
  gen str1 j = "j" 
  gen str1 k = "k"
  gen str1 l = "l"
  gen str1 m = "m"
  gen str1 n = "n"
  gen str1 o = "o"
  gen str1 p = "o"
  gen str1 q = "q"
  gen str1 r = "r"
  gen str1 s = "s"
  gen str1 t = "t"
  
global name "b c d e f g h i j k l" //need to update here when new waves added

gen wave=0
 }
 **

clear


  use "$RawDataUnS/xhhrel", clear
  save "$WorkData/raw_renamed/uns_xhhrel", replace
  
  use "$RawDataUnS/xwavedat", clear
  save "$WorkData/raw_renamed/uns_xwavedat", replace
  
  use "$RawDataUnS/xwaveid", clear
  save "$WorkData/raw_renamed/uns_xwaveid", replace
  
