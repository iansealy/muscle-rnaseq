png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_8.read_distr_pie.png",width=500,height=500,units="px")
pie(c(428171,116137),labels=c("Covered  428171 exons","Uncovered"),main="Exons",radius=0.6,clockwise=T,col=c("blue","white"))
dev.state = dev.off()
