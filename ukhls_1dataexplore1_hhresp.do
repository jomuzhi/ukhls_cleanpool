
*Pool household level info: houseownership, number of adults and children in one household
*for equalised income
*mortage
*Net household income

/*mortgage payers were asked the amount of their most recent total
monthly mortgage payment. Secured debt was then calculated by annualising this figure
and multiplying by the number of years left to run on the mortgage.
*/
clear
set more off

 *========UNderstanding Society hhresp data:=======

global unsoc "hidp wave hsownd tenuredv hhsize nkidsdv fihhmngrsdv fihhmnnet1dv fihhmngrsif agechydv hsbeds hsrooms intdatey strata psu ncars cduse* gordv"
/*other loan mgxty* */ /*cduse4 differs from wave18*/

*Different weights variables in different waves
use "$WorkData\1_hhresp", clear
    rename *_dv *dv
    rename *_if *if
    rename *_g3 *g3
    rename *_tc *tc
    rename *_xw *xw    
	rename *_* .*
	gen wave=1
    global wave 1
	count
	keep $unsoc hhdenusxw 
    rename hhdenusxw hhdenus_xw
    rename *dv *_dv
save "$WorkData/hhrespch_$wave.dta", replace


forval i=2/9 {
use "$WorkData/`i'_hhresp", clear
	rename *_dv *dv
    rename *_if *if
    rename *_g3 *g3
    rename *_tc *tc
    rename *_xw *xw
    rename *ff_* *ff*
	rename *_* .*
    
	gen wave=`i'
	keep $unsoc ///
        *xw
    rename *xw *_xw
    rename *dv *_dv
save "$WorkData/hhrespch_`i'.dta", replace
}
**


*--------------Append---------------*


use  "$WorkData\hhrespch_1.dta", clear
forval i=2/9{
append using "$WorkData\hhrespch_`i'.dta"
}
**
order wave
ta wave

forval i=1/9{
erase "$WorkData/hhrespch_`i'.dta"
}
**

