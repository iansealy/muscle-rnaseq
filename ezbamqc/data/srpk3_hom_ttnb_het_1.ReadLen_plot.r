png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_1.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(72,142,233,358,520,619,790,965,1142,1290,1714,1760,1886,2011,2357,2502,2831,2882,3586,3886,4442,5030,6480,6899,7315,8248,7933,8366,8924,9633,9334,9639,9597,10550,10066,10487,10556,10533,10964,11223,11141,11405,11573,11611,12098,11760,12244,11986,11997,12319,12552,17459,21346,22488,25120,25951,27956,28516,31170,31488,33694,35259,36330,37630,39003,40968,42706,45223,45544,46998,49049,50930,53250,54524,56509,58618,60320,61357,64543,65753,68429,72135,72820,74765,77644,80112,83393,85271,90703,91198,96111,98125,104459,115206,123753,127875,146172,149946,199950,253916,870853,1710565,23867672)
plot(readlen_val,(readlen_count/31584004),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()
