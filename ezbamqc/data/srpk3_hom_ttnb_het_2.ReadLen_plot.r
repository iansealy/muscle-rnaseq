png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_2.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(100,185,365,534,762,1119,1180,1482,1710,1960,2625,2686,2974,3096,3599,3718,4239,4620,5440,6324,7309,7975,10377,11205,11874,13505,12774,13595,14131,15465,14593,15306,15455,16348,16059,16329,16536,16801,16867,17196,17481,17794,17524,18302,18888,18694,18949,18604,18474,18964,19516,26555,31078,32176,35139,36508,39394,40838,43001,43829,46306,47675,50247,51641,52834,56533,58539,62140,62579,65054,67287,69686,72997,74391,77276,79913,81921,85109,88892,90976,95267,99544,100448,104173,108822,110239,115613,119030,126845,127216,136033,138055,148761,163034,177172,184025,214306,217812,293902,372039,1288040,2493972,34957924)
plot(readlen_val,(readlen_count/46093994),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()
