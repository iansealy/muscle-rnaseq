png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_10.mapq_profile.png",width=500,height=500,units="px")
mapq_val=c(0,1,3,255)
mapq_count=c(140434,413448,1103308,35703704)
xname=c("<3","<10","<20","<30","30-255")
freq = rep(0,5)
freq[1] = sum(mapq_count[which(mapq_val<3)])/37360896*100
freq[2] = sum(mapq_count[which(mapq_val<10)])/37360896*100
freq[3] = sum(mapq_count[which(mapq_val<20)])/37360896*100
freq[4] = sum(mapq_count[which(mapq_val<30)])/37360896*100
freq[5] = 100
barplot(freq,beside=T,xlab="Mapping Quality",border="NA",space=1.5,main="Mapping Quality",ylim=c(0,100),ylab="Cumulative proportion (%)",col="blue",names.arg=xname)
dev.state=dev.off()
