png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_1.read_distr_pie.png",width=500,height=500,units="px")
pie(c(440775,103533),labels=c("Covered  440775 exons","Uncovered"),main="Exons",radius=0.6,clockwise=T,col=c("blue","white"))
dev.state = dev.off()
