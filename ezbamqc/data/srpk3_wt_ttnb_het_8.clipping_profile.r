png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_8.clipping_profile.png",width=500,height=500,units="px")
read_pos=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149)
count=c(3963298,2974704,2458928,2331825,2217385,2123501,2032139,1946024,1864106,1785548,1714308,1645919,1579028,1514558,1450578,1390419,1332270,1275955,1221287,1168723,1117515,1067807,1019896,973252,928524,885480,843776,803353,764449,726801,690835,655927,621687,589152,557283,526787,497401,469648,443971,418465,394096,370721,348102,326903,306787,287717,269756,252756,236727,222404,209310,198706,190247,182164,174440,166611,159419,152394,145930,139773,133766,127721,122161,117029,112296,107482,103160,99017,95429,92405,89945,87809,86278,84888,83969,83340,83265,83452,83966,84974,86604,89245,92144,95307,98939,103124,107469,111955,116906,122222,127570,133762,140092,146365,152641,159248,166159,173096,180674,190381,202816,216583,232209,248524,266193,284543,304191,324431,346008,368458,392050,416575,441358,467965,495842,524602,554543,585449,617446,650676,685300,720714,758116,795740,834366,874185,915904,958777,1002994,1048581,1095888,1144307,1194493,1246141,1300110,1354759,1412494,1470559,1531127,1592253,1656093,1726552,1802655,1881370,1966155,2054197,2164852,2288027,2794681,3773953)
plot(read_pos,1-(count/37361856),pch=20,xlab="Position of reads",ylab="Mappability",col="blue")
dev.state=dev.off()