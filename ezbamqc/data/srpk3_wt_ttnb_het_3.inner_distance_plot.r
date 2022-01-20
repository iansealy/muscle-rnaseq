png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_3.inner_distance_plot.png",width=500,height=500,units="px")
fragsize=rep(c(-195,-185,-175,-165,-155,-145,-135,-125,-115,-105,-95,-85,-75,-65,-55,-45,-35,-25,-15,-5,5,15,25,35,45,55,65,75,85,95,105,115,125,135,145,155,165,175,185,195,205,215,225,235,245,255,265,275,285,295,305,315,325,335,345,355,365,375,385,395,405,415,425,435,445,455,465,475,485,495,505,515,525,535,545,555,565,575,585,595,605,615,625,635,645,655,665,675,685,695,705,715,725,735,745,755,765,775,785,795,805,815,825,835,845,855,865,875,885,895,905,915,925,935,945,955,965,975,985),times=c(91002,51927,46365,38969,144883,368361,387020,397538,400649,394512,395925,406590,407151,406880,402447,392432,386511,375412,361869,359039,311226,276708,249513,222864,197165,174832,156033,138886,124305,111492,99785,89991,81592,74687,68292,62435,57804,52459,48895,45303,40286,36938,33481,30583,27470,25104,22821,20723,19003,16913,15624,14327,12581,11083,10319,9091,8216,7795,7095,6387,7892,5313,5243,4573,4345,3911,3692,3421,3072,2913,2504,2360,2186,2055,1877,1777,1659,1649,1513,1437,1418,1274,1181,1139,1072,1056,1027,1025,954,920,830,702,677,693,619,659,676,596,536,467,478,458,439,392,406,337,388,356,383,292,343,301,291,308,303,300,309,323,288))
frag_sd = round(sd(fragsize),digits=0)
frag_mean = round(mean(fragsize),digits=0)
frag_median = round(median(fragsize),digits=0)
hist(fragsize,probability=T,breaks=120,xlim=c(-200,1000),xlab="Inner distance (bp)",main=paste(c("Median=",frag_median,";","Mean=",frag_mean,";","SD=",frag_sd),collapse=""),border="blue")
lines(density(fragsize,bw=20),col='red')
abline(v=frag_median,lty=2)
dev.state = dev.off()