library(corrplot)
srcfiles = c("output/data/srpk3_hom_ttnb_het_1.geneAbundance.txt","output/data/srpk3_hom_ttnb_het_2.geneAbundance.txt","output/data/srpk3_hom_ttnb_het_7.geneAbundance.txt","output/data/srpk3_hom_ttnb_het_8.geneAbundance.txt","output/data/srpk3_hom_ttnb_het_9.geneAbundance.txt","output/data/srpk3_hom_ttnb_het_10.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_1.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_4.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_5.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_6.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_7.geneAbundance.txt","output/data/srpk3_hom_ttnb_wt_8.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_1.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_2.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_3.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_7.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_8.geneAbundance.txt","output/data/srpk3_wt_ttnb_het_9.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_2.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_3.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_4.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_5.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_6.geneAbundance.txt","output/data/srpk3_wt_ttnb_wt_7.geneAbundance.txt")
destfile = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_corr.png"
f1 = read.delim(srcfiles[1],header=T)
MM=matrix(nrow=length(f1[,1]),ncol=length(srcfiles))
rownames(MM)=f1[,1]
MM[,1]=f1[,2]
for (i in 2:length(srcfiles)){ 
    f = read.delim(srcfiles[i],header=T)
    MM[,i] = f[,2] }
colnames(MM)=c("srpk3_hom_ttnb_het_1","srpk3_hom_ttnb_het_2","srpk3_hom_ttnb_het_7","srpk3_hom_ttnb_het_8","srpk3_hom_ttnb_het_9","srpk3_hom_ttnb_het_10","srpk3_hom_ttnb_wt_1","srpk3_hom_ttnb_wt_4","srpk3_hom_ttnb_wt_5","srpk3_hom_ttnb_wt_6","srpk3_hom_ttnb_wt_7","srpk3_hom_ttnb_wt_8","srpk3_wt_ttnb_het_1","srpk3_wt_ttnb_het_2","srpk3_wt_ttnb_het_3","srpk3_wt_ttnb_het_7","srpk3_wt_ttnb_het_8","srpk3_wt_ttnb_het_9","srpk3_wt_ttnb_wt_2","srpk3_wt_ttnb_wt_3","srpk3_wt_ttnb_wt_4","srpk3_wt_ttnb_wt_5","srpk3_wt_ttnb_wt_6","srpk3_wt_ttnb_wt_7")
libSize<-colSums(MM)
MM<-t(t(MM)*1000000/libSize)
ss<-rowSums(MM)
M1<-MM[ss>0,]
MM_s<-t(scale(t(M1)))
M.cor<-cor(MM_s,method='sp')
M.cor[is.na(M.cor)]<- 0
png(destfile,width=500,height=500,units='px')
corrplot(M.cor,is.corr=T,order='FPC',method='color',type='full',add=F,diag=T)
dev.state = dev.off()
nz_genes = length(M1[,1])
destfile = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_reproducibility.png"
if(nz_genes >0) { 
png(destfile,width=500,height=500,units='px')
nz_gene_mm = rep(0,length(M1[1,]))
for(i in 1:length(M1[1,])) { 
nz_gene_mm[i] = length(which(M1[,i]>0))/nz_genes * 100 } 
bplt <- barplot(nz_gene_mm,beside=T,border='NA',space=1.5,ylim=c(0,100),ylab='Genes reproducibly detected (%)',col='blue',names.arg=colnames(MM),las=2)
text(y= nz_gene_mm+2, x= bplt, labels=paste(as.character(round(nz_gene_mm,digits=1)),'%',sep=''), xpd=TRUE)
dev.state = dev.off()}
destfile = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_var.png"
png(destfile,width=500,height=500,units='px')
mad = rep(0,length(M1[,1]))
nz_gene_median = rep(0,length(M1[,1]))
for(i in 1:length(M1[,1])) { 
nz_gene_median[i] = median(M1[i,]) 
mad[i] = median(abs(M1[i,]-nz_gene_median[i])) } 
mad2 = mad[nz_gene_median >0] 
nz_gene_median2 = nz_gene_median[nz_gene_median>0] 
mad_vs_median = mad2/nz_gene_median2 
nz_gene_median3 = log(nz_gene_median2, base=2)
dd<-data.frame(nz_gene_median3,mad_vs_median) 
x = densCols(nz_gene_median3,mad_vs_median, colramp=colorRampPalette(c('black', 'white')))
dd$dens <- col2rgb(x)[1,] + 1L 
cols <-  colorRampPalette(c("#000099", "#00FEFF", "#45FE4F", "#FCFF00", "#FF9400", "#FF3100"))(256)
dd$col <- cols[dd$dens]
plot(mad_vs_median ~ nz_gene_median3,data=dd[order(dd$dens),], col=col, pch=20,xlab="Gene expression (median RPM log2)",ylab="Median absolute deviation/median")
dev.state = dev.off()
destfile = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_cov.png"
png(destfile,width=500,height=500,units='px')
xname=c("<0.5","0.5-10","10-100",">=100")
Fn_mm = matrix(0,nrow=length(xname),ncol=length(M1[1,]))
rownames(Fn_mm) = xname 
colnames(Fn_mm) = c("srpk3_hom_ttnb_het_1","srpk3_hom_ttnb_het_2","srpk3_hom_ttnb_het_7","srpk3_hom_ttnb_het_8","srpk3_hom_ttnb_het_9","srpk3_hom_ttnb_het_10","srpk3_hom_ttnb_wt_1","srpk3_hom_ttnb_wt_4","srpk3_hom_ttnb_wt_5","srpk3_hom_ttnb_wt_6","srpk3_hom_ttnb_wt_7","srpk3_hom_ttnb_wt_8","srpk3_wt_ttnb_het_1","srpk3_wt_ttnb_het_2","srpk3_wt_ttnb_het_3","srpk3_wt_ttnb_het_7","srpk3_wt_ttnb_het_8","srpk3_wt_ttnb_het_9","srpk3_wt_ttnb_wt_2","srpk3_wt_ttnb_wt_3","srpk3_wt_ttnb_wt_4","srpk3_wt_ttnb_wt_5","srpk3_wt_ttnb_wt_6","srpk3_wt_ttnb_wt_7") 
for(i in 1:length(M1[1,])) { 
Fn_mm[1,i] = length(which(M1[,i]<0.5)) 
Fn_mm[2,i] = length(which(M1[,i]>=0.5 & M1[,i]<10))
Fn_mm[3,i] = length(which(M1[,i]>=10 & M1[,i]<100))
Fn_mm[4,i] = length(which(M1[,i]>=100)) }
barplot(Fn_mm,main="Gene abundance (RPM)",xlab="Sample",ylab="Frequency",col=c("green","blue","red","yellow"),legend=xname,las=2)
dev.state = dev.off()
srcfiles2 = c("output/data/srpk3_hom_ttnb_het_1.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_het_2.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_het_7.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_het_8.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_het_9.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_het_10.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_1.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_4.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_5.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_6.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_7.inner_distance_freq.txt","output/data/srpk3_hom_ttnb_wt_8.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_1.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_2.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_3.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_7.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_8.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_het_9.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_2.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_3.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_4.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_5.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_6.inner_distance_freq.txt","output/data/srpk3_wt_ttnb_wt_7.inner_distance_freq.txt")
destfile2 = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_inner_dist.png"
png(destfile2,width=500,height=500,units='px')
f = read.delim(srcfiles2[1],header=T)
freq=rep(round((f[,1]+f[,2]+1)/2,0),times=f[,3])
smp =c("srpk3_hom_ttnb_het_1","srpk3_hom_ttnb_het_2","srpk3_hom_ttnb_het_7","srpk3_hom_ttnb_het_8","srpk3_hom_ttnb_het_9","srpk3_hom_ttnb_het_10","srpk3_hom_ttnb_wt_1","srpk3_hom_ttnb_wt_4","srpk3_hom_ttnb_wt_5","srpk3_hom_ttnb_wt_6","srpk3_hom_ttnb_wt_7","srpk3_hom_ttnb_wt_8","srpk3_wt_ttnb_het_1","srpk3_wt_ttnb_het_2","srpk3_wt_ttnb_het_3","srpk3_wt_ttnb_het_7","srpk3_wt_ttnb_het_8","srpk3_wt_ttnb_het_9","srpk3_wt_ttnb_wt_2","srpk3_wt_ttnb_wt_3","srpk3_wt_ttnb_wt_4","srpk3_wt_ttnb_wt_5","srpk3_wt_ttnb_wt_6","srpk3_wt_ttnb_wt_7")
boxplot(freq,outline=F,xlim=c(0,length(smp)+1),ylab="Inner distance (bp)",col="blue",border="black") 
for (i in 2:length(srcfiles2)){ 
    f = read.delim(srcfiles2[i],header=T)
freq=rep(round((f[,1]+f[,2]+1)/2,0),times=f[,3])
boxplot(freq,add=T,outline=F,at=i,col="blue",border="black") }
axis(1,at=seq(1,length(smp),by=1),labels=smp,las=2)
dev.state = dev.off()
destfile3 = "/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/smp_qual.png"
srcfiles3 = c("output/data/srpk3_hom_ttnb_het_1.mapq_profile.xls","output/data/srpk3_hom_ttnb_het_2.mapq_profile.xls","output/data/srpk3_hom_ttnb_het_7.mapq_profile.xls","output/data/srpk3_hom_ttnb_het_8.mapq_profile.xls","output/data/srpk3_hom_ttnb_het_9.mapq_profile.xls","output/data/srpk3_hom_ttnb_het_10.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_1.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_4.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_5.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_6.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_7.mapq_profile.xls","output/data/srpk3_hom_ttnb_wt_8.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_1.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_2.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_3.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_7.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_8.mapq_profile.xls","output/data/srpk3_wt_ttnb_het_9.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_2.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_3.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_4.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_5.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_6.mapq_profile.xls","output/data/srpk3_wt_ttnb_wt_7.mapq_profile.xls")
png(destfile3,width=500,height=500,units='px')
xname=c("<3","3-10","10-20","20-30",">=30")
Fn_mm = matrix(0,nrow=length(xname),ncol=length(srcfiles3))
rownames(Fn_mm) = xname 
colnames(Fn_mm) = c("srpk3_hom_ttnb_het_1","srpk3_hom_ttnb_het_2","srpk3_hom_ttnb_het_7","srpk3_hom_ttnb_het_8","srpk3_hom_ttnb_het_9","srpk3_hom_ttnb_het_10","srpk3_hom_ttnb_wt_1","srpk3_hom_ttnb_wt_4","srpk3_hom_ttnb_wt_5","srpk3_hom_ttnb_wt_6","srpk3_hom_ttnb_wt_7","srpk3_hom_ttnb_wt_8","srpk3_wt_ttnb_het_1","srpk3_wt_ttnb_het_2","srpk3_wt_ttnb_het_3","srpk3_wt_ttnb_het_7","srpk3_wt_ttnb_het_8","srpk3_wt_ttnb_het_9","srpk3_wt_ttnb_wt_2","srpk3_wt_ttnb_wt_3","srpk3_wt_ttnb_wt_4","srpk3_wt_ttnb_wt_5","srpk3_wt_ttnb_wt_6","srpk3_wt_ttnb_wt_7") 
for(i in 1:length(srcfiles3)) { 
  f = read.delim(srcfiles3[i],header=T)
 if(length(which(f[,1]<3)) >0){ Fn_mm[1,i] = sum(f[which(f[,1]<3),3])/f[1,2]} 
if(length(which(f[,1]>=3 & f[,1]<10)) >0) {Fn_mm[2,i] = sum(f[which(f[,1]<10 & f[,1]>=3),3])/f[1,2]} 
if(length(which(f[,1]>=10 & f[,1]<20)) >0)  {Fn_mm[3,i] = sum(f[which(f[,1]<20 & f[,1]>=10),3])/f[1,2] }
if(length(which(f[,1]>=20 & f[,1]<30)) >0) {Fn_mm[4,i] = sum(f[which(f[,1]<30 & f[,1]>=20),3])/f[1,2]} 
if(length(which(f[,1]>=30)) >0) {Fn_mm[5,i] = sum(f[which(f[,1]>=30),3])/f[1,2] }} 
barplot(Fn_mm,xlab="Sample",main="Mapping Quality",ylim=c(0,1),ylab="Frequency",col=c("blue","green","yellow","orange","red"),legend=xname,las=2)
dev.state = dev.off()
