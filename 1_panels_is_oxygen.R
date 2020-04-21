#Boilerplate
library("ggpubr")
library(ggplot2)
library(dplyr)
library(ggpubr)
setwd('/Users/riverkano/Desktop/R_firstfig/VEGFA')

#Import tpm matrix, get means and stuff
tpm <- read.table('VEGFA_counts.tsv', header = TRUE)



for (conc in c('2.5', '5.0', 'ATM')){

conc.set <- subset(tpm, oxygen==conc)
conc.set.andmu <- subset (conc.set, genotype=='andmu')
conc.set.andwt <- subset (conc.set, genotype=='andwt')
conc.set.daimu <- subset (conc.set, genotype=='daimu')
conc.set.daiwt <- subset (conc.set, genotype=='daiwt')


#Make a graph where each series is an O2 conc, 1 graph for each genotype

mmax <- max(tpm$X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715)
gmax <- mmax+(mmax*0.2)
mmin <- min(tpm$X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715)
gmin <- mmin-(mmin*0.2)

ggplot(conc.set, aes(time, X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715, colour = genotype)) +
            scale_color_manual(values=c('red','darkred','blue1', 'navy'))+
            geom_point(size = 0.5, position=position_dodge(5)) +   
            stat_summary(data = conc.set.andmu, aes(y = X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715, group="genotype"), fun.y=mean, colour="red", geom="line",group=1) +
            stat_summary(data = conc.set.andwt, aes(y = X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715, group="genotype"), fun.y=mean, colour="darkred", geom="line",group=1) +
            stat_summary(data = conc.set.daimu, aes(y = X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715, group="genotype"), fun.y=mean, colour="blue1", geom="line",group=1) +
            stat_summary(data = conc.set.daiwt, aes(y = X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715, group="genotype"), fun.y=mean, colour="navy", geom="line",group=1) +
            labs(colour = "Genotype") +
            labs(x = "Time (hours)") +
            labs(y = "Reads (TPM)") +
            ylim(0,max(tpm$X2370fdd7.1496.4811.9929.6835d9afe9b6_ENSG00000112715))

ggsave(filename=paste(conc,".pdf",sep=""), scale = 1, width = 120, height = 80, units = "mm")}
  

