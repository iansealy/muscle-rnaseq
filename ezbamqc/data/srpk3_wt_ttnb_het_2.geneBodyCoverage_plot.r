png('/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_het_2.geneBodyCoverage.png',width=500,height=500,units='px')
x=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100)
y=c(98775,270890,464417,658337,781110,892946,1006385,1141411,1234982,1309449,1370896,1459949,1509986,1508875,1549865,1632855,1665324,1748327,1797394,1815680,1858712,1873214,1875718,1894217,1863652,1874232,1842513,1797563,1774278,1776974,1779062,1788514,1795443,1851120,1851388,1849763,1826482,1825639,1841766,1823138,1811313,1814629,1824788,1833328,1805034,1774985,1785178,1810571,1825770,1830257,1846983,1883250,1885003,1843591,1840907,1847000,1846711,1870685,1871801,1873171,1858354,1843461,1823671,1813458,1799082,1780504,1716842,1713680,1737662,1755514,1800800,1816529,1795999,1779743,1765119,1753649,1726588,1701325,1686955,1668256,1643924,1602586,1636946,1619325,1567070,1511257,1471235,1411535,1377148,1339514,1274108,1210073,1142955,1057301,976000,875203,750764,641628,519271,381593,219018)
smoothsp = smooth.spline(x,y,spar=0.35)
plot(smoothsp,type="l",col="blue",xlab="Percentile of Gene Body (5'->3')",ylab="Number of read",xlim=c(0,100))
dev.state = dev.off()