#This script finds the frequency of reads of certain lengths for sams mapped to genome 38
#This code will not work without first installing the packages below

library(ggplot2)
library(plyr)

setwd("/data/cephfs/punim0586/rkano/pilotpilot/qcat/barcode05/freqtables")
files = list.files(pattern='*.csv')

#Imports all csv files, using space as separator
for (i in 1:length(files)){
  assign(files[i], 
         read.table(paste(files[i], sep=''))
  )}

#Makes a list of all my objects
dflist <- Filter(function(x) is(x, "data.frame"), mget(ls()))

#Renames the second column to the filename
for( i in 1:length(dflist)) names( dflist[[i]])[1] <- names(dflist)[i]
list2env(dflist, .GlobalEnv)

#Merges all the dataframes into one
sortx = join_all(dflist, by='V2', type='full')

#Replaces NA with 0
sortx[is.na(sortx)] <- 0

#Adds row sums
sortx$total.freq <- ((rowSums(sortx))-sortx$V2)

#Delete the (1) row
sortx <- sortx[-c(1),]

#Gives total short and long reads
cutoff = 1000
short <- (subset(sortx, V2 < cutoff))
long <- (subset(sortx, V2 > cutoff))
sum(short$total.freq)
sum(long$total.freq)
