png('/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_3.geneBodyCoverage.png',width=500,height=500,units='px')
x=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100)
y=c(78896,216122,373281,528306,631160,727072,822537,935904,1017557,1086439,1143354,1217455,1260137,1263160,1299923,1359851,1387133,1455809,1495023,1510279,1546759,1558520,1563678,1583778,1557966,1565969,1539509,1499135,1480223,1481824,1486092,1497667,1505722,1547540,1547718,1546276,1527161,1527567,1542003,1525928,1516401,1516409,1527014,1535035,1507660,1487196,1491448,1507587,1517322,1522946,1535409,1557548,1560101,1525890,1521356,1524736,1521771,1536033,1540010,1540483,1527618,1518795,1503343,1491469,1479559,1467136,1417902,1412631,1430957,1448072,1481594,1484907,1468615,1455208,1444539,1437653,1418368,1396844,1382381,1369026,1348352,1322872,1342927,1322833,1282857,1236562,1198986,1148830,1119697,1086483,1031660,982014,927590,872302,804084,719778,620245,526665,425422,312600,176283)
smoothsp = smooth.spline(x,y,spar=0.35)
plot(smoothsp,type="l",col="blue",xlab="Percentile of Gene Body (5'->3')",ylab="Number of read",xlim=c(0,100))
dev.state = dev.off()