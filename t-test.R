setwd('/Users/riverkano/Desktop/R_firstfig/VEGFA')
counts <- read.table('VEGFA_counts.tsv', header = TRUE)
library(plyr)

i <- rlang::expr(t.test(X7278308c.6e95.4594.b30d.f9cf5109d24f_ENSG00000112715 ~ genotype, conc.set.and)$p.value)

for (t in c(0,12,24,48)){
tpm <- subset(counts, time==t)

conc <- '2.5'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='andmu' | genotype=='andwt')
and2 <- eval(i)

conc <- '5.0'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='andmu' | genotype=='andwt')
and5 <- eval(i)

conc <- 'ATM'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='andmu' | genotype=='andwt')
andA <- eval(i)

and <- append (and2, c(and5, andA))
and
#and is the p values from the t test for: 2.5, 5.0, ATM

conc <- '2.5'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='daimu' | genotype=='daiwt')
dai2 <- eval(i)

conc <- '5.0'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='daimu' | genotype=='daiwt')
dai5 <- eval(i)

conc <- 'ATM'
conc.set <- subset(tpm, oxygen==conc)
conc.set.and <- subset(conc.set, genotype=='daimu' | genotype=='daiwt')
daiA <- eval(i)

dai <- append (dai2, c(dai5, daiA))
and


#now one that puts them together
header <- c('2.5','5.0','ATM')
tab <- data.frame(header, dai, and)
tab
j <- quote('h.table')
assign(paste(t,j, sep = ""), tab)}

allthre <- rbind.fill(`0h.table`,`12h.table`,`24h.table`,`48h.table`)
time <- c(0,0,0,4,4,4,24,24,24,48,48,48)
allthree <- data.frame(time, allthre)
write.csv(allthree, 'X7278308c.6e95.4594.b30d.f9cf5109d24f_ENSG00000112715.csv')
rm(list = ls())
