png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_1.mapq_profile.png",width=500,height=500,units="px")
mapq_val=c(0,1,3,255)
mapq_count=c(118428,339178,995428,32563322)
xname=c("<3","<10","<20","<30","30-255")
freq = rep(0,5)
freq[1] = sum(mapq_count[which(mapq_val<3)])/34016358*100
freq[2] = sum(mapq_count[which(mapq_val<10)])/34016358*100
freq[3] = sum(mapq_count[which(mapq_val<20)])/34016358*100
freq[4] = sum(mapq_count[which(mapq_val<30)])/34016358*100
freq[5] = 100
barplot(freq,beside=T,xlab="Mapping Quality",border="NA",space=1.5,main="Mapping Quality",ylim=c(0,100),ylab="Cumulative proportion (%)",col="blue",names.arg=xname)
dev.state=dev.off()
