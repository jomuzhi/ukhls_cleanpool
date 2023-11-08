# ukhls_cleanpool
using STATA to clean and pool BHPS1991 (18 waves) and after and Understanding Society 2009 (up to now 12 waves) and after wave

UKHLS data are a high-quality data with large sample size. 

The data organization is complext, but using the stata do files should be able to pool all wave essential variables from each wave.

For Understanding Society data [(SN: 6614)](https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=6614) only, since 2009, then. 

Set up your own working directory, then replace it at the top of each do file.

These do files can pool individual and household levels data and combine them together. You can easily add or remove new variables that you are interested. Just run the do files in sequences as indicated by the names 0.., 1..., 2...
