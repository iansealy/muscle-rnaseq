png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_2.inner_distance_plot.png",width=500,height=500,units="px")
fragsize=rep(c(-195,-185,-175,-165,-155,-145,-135,-125,-115,-105,-95,-85,-75,-65,-55,-45,-35,-25,-15,-5,5,15,25,35,45,55,65,75,85,95,105,115,125,135,145,155,165,175,185,195,205,215,225,235,245,255,265,275,285,295,305,315,325,335,345,355,365,375,385,395,405,415,425,435,445,455,465,475,485,495,505,515,525,535,545,555,565,575,585,595,605,615,625,635,645,655,665,675,685,695,705,715,725,735,745,755,765,775,785,795,805,815,825,835,845,855,865,875,885,895,905,915,925,935,945,955,965,975,985),times=c(116919,65895,57046,47744,187802,491550,513484,522328,521605,504923,500833,509978,508455,499469,485002,474587,463498,444693,426178,421962,365255,325161,293448,261387,232343,206248,184832,165143,146985,132014,118545,105776,97126,89248,81451,75861,70317,64634,59593,55007,49951,45403,41415,37409,34462,31407,28559,26566,24353,21908,19790,18241,15853,14697,13343,11940,10811,10184,8930,8435,9623,7211,6753,6076,5586,5122,4714,4458,3935,3750,3294,3167,2822,2548,2398,2239,2150,1970,2003,1795,1553,1629,1534,1359,1379,1305,1340,1181,1078,1074,1002,814,837,859,799,748,734,734,660,650,570,600,505,512,479,439,498,435,396,353,417,363,383,410,348,321,351,346,279))
frag_sd = round(sd(fragsize),digits=0)
frag_mean = round(mean(fragsize),digits=0)
frag_median = round(median(fragsize),digits=0)
hist(fragsize,probability=T,breaks=120,xlim=c(-200,1000),xlab="Inner distance (bp)",main=paste(c("Median=",frag_median,";","Mean=",frag_mean,";","SD=",frag_sd),collapse=""),border="blue")
lines(density(fragsize,bw=20),col='red')
abline(v=frag_median,lty=2)
dev.state = dev.off()
