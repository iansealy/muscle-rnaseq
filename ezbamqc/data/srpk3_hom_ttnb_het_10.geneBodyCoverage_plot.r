png('/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_10.geneBodyCoverage.png',width=500,height=500,units='px')
x=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100)
y=c(122071,337230,577061,814131,966278,1104701,1243664,1415416,1533003,1628015,1710768,1818792,1883321,1885244,1936599,2012214,2045404,2142926,2198333,2219376,2269655,2278722,2281786,2320653,2288246,2289999,2251334,2193526,2166590,2166182,2172687,2184291,2194588,2239106,2246498,2243839,2213980,2214802,2241397,2222277,2211215,2212369,2223797,2232121,2199202,2166177,2161570,2187076,2200423,2205952,2224698,2260764,2258976,2207693,2204774,2212851,2207041,2219921,2219995,2216665,2201374,2182426,2158072,2143181,2124789,2108029,2039015,2034247,2067771,2091935,2125715,2140242,2114234,2095742,2076472,2062621,2033195,2003552,1985061,1959552,1930272,1891860,1913117,1885834,1824886,1759276,1709915,1637162,1595626,1550705,1472922,1399029,1319619,1242028,1148135,1030105,888341,755188,610739,448713,258990)
smoothsp = smooth.spline(x,y,spar=0.35)
plot(smoothsp,type="l",col="blue",xlab="Percentile of Gene Body (5'->3')",ylab="Number of read",xlim=c(0,100))
dev.state = dev.off()