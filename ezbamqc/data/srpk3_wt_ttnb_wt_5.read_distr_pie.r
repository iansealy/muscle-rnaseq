png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_5.read_distr_pie.png",width=500,height=500,units="px")
pie(c(439778,104530),labels=c("Covered  439778 exons","Uncovered"),main="Exons",radius=0.6,clockwise=T,col=c("blue","white"))
dev.state = dev.off()
