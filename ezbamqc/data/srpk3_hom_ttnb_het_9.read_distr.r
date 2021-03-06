png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_9.read_distr.png",width=500,height=500,units="px")
M=c(12389120,271658,2804959,1256886,59101,441970,2617,1686761)
Mname=c("CDS","5UTR","3UTR","Intron","TSS_Up_1Kb","TES_Down_1Kb","rRNA","Others")
val = barplot(M,xlab="",space=1,ylab="Read Counts",col="blue",border="NA")
text(x=seq(val[1],val[8],by=2),y=rep(0,8),srt=60,adj=0,offset=2,pos=1,xpd=T,labels=Mname)
dev.state = dev.off()
