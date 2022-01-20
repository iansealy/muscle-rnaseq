png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_wt_1.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(85,148,304,425,613,788,971,1123,1292,1558,2005,2124,2281,2539,2845,2975,3411,3670,4351,5163,5692,6454,8277,8762,9365,10518,10000,10210,11130,12033,11657,12024,12093,13240,12505,12989,13233,12998,13684,13633,13786,13932,13925,14186,14761,14493,14727,14763,14685,15167,15538,20962,25040,26146,28883,29952,31611,32894,35033,36177,38804,39731,41404,42314,44229,46035,48479,51422,51950,53525,55418,57966,60465,60960,63611,65243,66783,69730,72080,74282,77391,81473,82669,83819,88782,90158,94428,97049,102877,103539,110300,111150,119788,130957,142969,145986,168318,175053,234562,297368,1039144,2019034,27730086)
plot(readlen_val,(readlen_count/36735300),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()
