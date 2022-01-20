png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_2.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(70,131,230,380,459,674,775,942,1071,1181,1553,1614,1773,1807,2181,2316,2641,2777,3258,3712,4250,4859,6015,6496,6883,7753,7280,7858,8340,9216,8674,8975,9093,9563,9475,9746,10009,9958,10320,10364,10292,10804,10456,10855,11362,11215,11337,11375,11626,11718,12002,16085,19617,20688,23237,24254,26196,26391,28661,29204,31203,32249,33591,34872,36568,37984,40385,42009,43370,43828,45561,48041,49648,50899,53286,55096,56235,57665,60082,62460,64977,66937,68620,70406,73183,75116,78954,80498,85916,86649,91359,92292,98921,108315,118252,122508,139007,144568,191502,243681,840141,1646445,22746466)
plot(readlen_val,(readlen_count/30093924),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()