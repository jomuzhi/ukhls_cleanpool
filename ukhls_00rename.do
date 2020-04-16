*XXXXXXXXXXXXXXXXXXXXXXXXXXXX*
*Data Rename
//rename files to have consistent names for later analysis
//all saved as workdata
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*
 clear
 set more off
 
 global onedrive "C:\Users\Muzhi\OneDrive - Nexus365\Academia\Data\UKHLS_do\Stata_public"
 //change to your own directory where you saved your do files
 
 do "$onedrive/do/ukhls_00dir"
 capture log close 
 

*================UnSoc Rename===================
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
 
 global filename "adopt callrec child cohab egoalt empstat hhresp hhsamp income indall indresp issue marriage natchild youth"
 
foreach var in $filename {
 use "$RawData/ukhls_w1/a_`var'.dta", clear
 save "$WorkData/1_`var'.dta", replace
}
**

 gen newborn="newborn"
 gen parstyle="parstyle"
 global filename "adopt callrec cohab marriage natchild"
  
  
 foreach var in $filename {
 use "$RawData/ukhls_w6/f_`var'.dta", clear
 save "$WorkData/6_`var'.dta", replace
}
**


 *2. Same files shared from wave 2
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
  
global name "b c d e f g h i"

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
 /*
 local wn=wave
 local waven=wave+18
 */
 local wn=wave
 local waven=wave
 
 use "$RawData/ukhls_w`wn'/`var'_callrec", clear
 save "$WorkData/`waven'_callrec", replace
 
  use "$RawData/ukhls_w`wn'/`var'_child", clear
 save "$WorkData/`waven'_child", replace
 
  use "$RawData/ukhls_w`wn'/`var'_egoalt", clear
 save "$WorkData/`waven'_egoalt", replace
 
  use "$RawData/ukhls_w`wn'/`var'_hhresp", clear
 save "$WorkData/`waven'_hhresp", replace
 
  use "$RawData/ukhls_w`wn'/`var'_hhsamp", clear
 save "$WorkData/`waven'_hhsamp", replace
 
  use "$RawData/ukhls_w`wn'/`var'_income", clear
 save "$WorkData/`waven'_income", replace
 
  use "$RawData/ukhls_w`wn'/`var'_indall", clear
 save "$WorkData/`waven'_indall", replace
 
  use "$RawData/ukhls_w`wn'/`var'_indresp", clear
 save "$WorkData/`waven'_indresp", replace
 /*
  use "$RawData/ukhls_w`wn'/`var'_issue", clear
 save "$WorkData/`waven'_issue", replace
 */
  use "$RawData/ukhls_w`wn'/`var'_youth", clear
 save "$WorkData/`waven'_youth", replace
 
    use "$RawData/ukhls_w`wn'/`var'_indsamp", clear
 save "$WorkData/`waven'_indsamp", replace
 
  
  use "$RawData/ukhls_w`wn'/`var'_newborn", clear
 save "$WorkData/`waven'_newborn", replace
 
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
  
global name "b c d e f g h i"

gen wave=0
 }
 **
 
*3. _issue is missing in certain wave


*4. Some files start to exsit in later waves/alternating waves
gen chmain="chmain" //in w3, w5, w7, w9
global name "c e g i"
foreach var in $name{
 replace wave=3 if `var'=="c" 
 replace wave=5 if `var'=="e" 
 replace wave=7 if `var'=="g" 
 replace wave=9 if `var'=="i" 
 local wn=wave
 local waven=wave
 
 use "$RawData/ukhls_w`wn'/`var'_chmain", clear
 save "$WorkData/`waven'_chmain", replace 
  
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
  
global name "c e g i"
gen wave=0
 }
 **

gen parstyle="parstyle" //in w3, w4, w5, w6, w7, 8, 

global name "c d e f g h i"
foreach var in $name{
 replace wave=3 if `var'=="c"
 replace wave=4 if `var'=="d"
 replace wave=5 if `var'=="e"
 replace wave=6 if `var'=="f"
 replace wave=7 if `var'=="g"
 replace wave=8 if `var'=="h"
 replace wave=9 if `var'=="i"
 
 local wn=wave
 local waven=wave
  
  use "$RawData/ukhls_w`wn'/`var'_parstyle", clear
 save "$WorkData/`waven'_parstyle", replace
 
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
  
global name "c d e f g h i"

gen wave=0
 }
 **



clear
