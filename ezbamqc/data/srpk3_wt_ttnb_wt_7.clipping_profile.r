png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_7.clipping_profile.png",width=500,height=500,units="px")
read_pos=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149)
count=c(4692036,3515815,2869260,2716142,2577721,2465858,2358587,2257164,2159372,2066164,1982917,1903796,1825450,1750330,1676987,1607381,1540000,1476040,1413990,1354706,1297070,1240357,1185701,1133639,1083174,1034812,988275,942802,899195,856842,816341,777577,739986,703731,668777,635369,603077,572021,542898,514997,488274,462721,437722,414476,392069,370834,350565,331340,313237,296479,280300,266468,255082,244403,233809,223378,213642,204236,195528,187134,178658,170688,163441,156437,149822,143294,137403,132047,127041,122722,119113,115976,113296,111251,109605,108513,108103,108093,108608,109998,111968,115078,118314,122203,126906,132134,137923,143797,149844,156863,163906,171489,179720,187809,196190,204886,213816,223161,232783,244711,259099,274864,291886,309716,329017,348888,370204,391840,414679,438581,463682,490168,517828,547045,577351,608566,640843,674384,708980,745376,783739,822517,863709,906008,948694,992992,1039271,1087012,1136861,1188161,1241854,1297051,1355172,1414717,1476770,1539841,1606495,1673788,1744977,1817215,1891824,1974492,2063436,2155306,2255031,2359853,2494586,2645213,3282419,4453281)
plot(read_pos,1-(count/48144124),pch=20,xlab="Position of reads",ylab="Mappability",col="blue")
dev.state=dev.off()
