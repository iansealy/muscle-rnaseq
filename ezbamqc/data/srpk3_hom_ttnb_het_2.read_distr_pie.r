png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_2.read_distr_pie.png",width=500,height=500,units="px")
pie(c(448376,95932),labels=c("Covered  448376 exons","Uncovered"),main="Exons",radius=0.6,clockwise=T,col=c("blue","white"))
dev.state = dev.off()
