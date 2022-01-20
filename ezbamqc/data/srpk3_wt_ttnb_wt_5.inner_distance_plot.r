png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_5.inner_distance_plot.png",width=500,height=500,units="px")
fragsize=rep(c(-195,-185,-175,-165,-155,-145,-135,-125,-115,-105,-95,-85,-75,-65,-55,-45,-35,-25,-15,-5,5,15,25,35,45,55,65,75,85,95,105,115,125,135,145,155,165,175,185,195,205,215,225,235,245,255,265,275,285,295,305,315,325,335,345,355,365,375,385,395,405,415,425,435,445,455,465,475,485,495,505,515,525,535,545,555,565,575,585,595,605,615,625,635,645,655,665,675,685,695,705,715,725,735,745,755,765,775,785,795,805,815,825,835,845,855,865,875,885,895,905,915,925,935,945,955,965,975,985),times=c(127456,72504,62991,53338,203788,522915,547597,559199,561795,544942,542946,555159,553805,547883,534963,524288,511904,493527,475803,468954,405377,359672,324181,289534,255806,226886,202377,180170,161684,144420,130300,117139,107194,98117,89335,82129,76426,70676,64857,60361,54681,49788,45437,41455,37354,34451,31368,28554,26046,23400,21619,19807,17613,16095,14348,12903,11861,10890,9913,8968,11009,7848,7469,6800,6133,5434,5253,4690,4368,4054,3666,3349,3149,2858,2646,2418,2397,2127,2185,1998,1931,1790,1693,1647,1618,1441,1382,1358,1265,1251,1193,1021,973,937,836,850,937,855,736,733,696,601,584,591,519,538,523,520,450,469,485,430,465,456,398,393,447,389,375))
frag_sd = round(sd(fragsize),digits=0)
frag_mean = round(mean(fragsize),digits=0)
frag_median = round(median(fragsize),digits=0)
hist(fragsize,probability=T,breaks=120,xlim=c(-200,1000),xlab="Inner distance (bp)",main=paste(c("Median=",frag_median,";","Mean=",frag_mean,";","SD=",frag_sd),collapse=""),border="blue")
lines(density(fragsize,bw=20),col='red')
abline(v=frag_median,lty=2)
dev.state = dev.off()