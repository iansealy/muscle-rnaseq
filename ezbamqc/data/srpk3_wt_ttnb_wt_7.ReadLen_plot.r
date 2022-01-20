png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_7.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(100,190,368,510,753,1136,1253,1545,1783,2050,2661,2792,2978,3189,3755,4008,4449,4743,5881,6353,7569,8272,10892,11632,12534,13942,13266,14016,14567,16236,15333,16072,15940,16781,16579,16721,17345,17345,18007,18141,17831,18890,18717,18624,19833,19237,19593,19872,19728,19784,20562,27638,32699,33880,36280,37901,40700,42065,44338,45540,48483,50013,52380,54279,56597,59359,61198,65380,65617,67689,69973,73336,75932,77896,81721,83919,85125,88416,92086,94248,98892,103464,104639,107854,112871,115274,120622,123521,130933,132231,141626,143057,152808,169638,183586,188965,216533,225514,302417,380595,1306738,2430130,36746466)
plot(readlen_val,(readlen_count/48144124),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()