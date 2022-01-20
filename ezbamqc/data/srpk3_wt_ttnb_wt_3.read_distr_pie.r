png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_3.read_distr_pie.png",width=500,height=500,units="px")
pie(c(441277,103031),labels=c("Covered  441277 exons","Uncovered"),main="Exons",radius=0.6,clockwise=T,col=c("blue","white"))
dev.state = dev.off()
