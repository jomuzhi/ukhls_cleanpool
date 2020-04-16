*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
*Common Do File *Study Number: 6614
*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

*Author: Muzhi ZHOU
*file path directory:
 
*File directory

*Set up file folders named as: do, pics, and workdata
* to save do files, generated stata graphs, and work data

 global RawData    "D:\Academia\Data\UKHLS\RawData\UKDA-6614-stata\stata\stata11_se"
 //latest understanding society data
 
 global WorkData $onedrive/workdata
 
 ****************************************************
/*
*add programs

ssc install grstyle
ssc install kdens
ssc install moremata
ssc install coefplot
ssc install grc1leg
ssc install center 
ssc install esttab 
ssc install xtfeis

*/