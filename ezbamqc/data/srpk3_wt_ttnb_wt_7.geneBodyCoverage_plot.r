png('/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_wt_ttnb_wt_7.geneBodyCoverage.png',width=500,height=500,units='px')
x=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100)
y=c(148309,414523,711130,998424,1193555,1364839,1539965,1745118,1892405,2012268,2105912,2246039,2334333,2329146,2388895,2510226,2556993,2683811,2761660,2789302,2868349,2891286,2896297,2928847,2887612,2901414,2857662,2796563,2760998,2758926,2766099,2782783,2789298,2873854,2880640,2877346,2842640,2841140,2864717,2832034,2816091,2822376,2838161,2854123,2807471,2760143,2771421,2820429,2841296,2854938,2880620,2923948,2930709,2874288,2873028,2885557,2887048,2927457,2926658,2935885,2916953,2896031,2859817,2842367,2819499,2795618,2702299,2695273,2734841,2757917,2824862,2842385,2808606,2785907,2757878,2744731,2707495,2666073,2646609,2616151,2564447,2503996,2544384,2516418,2436480,2348953,2283104,2184162,2131864,2069693,1972596,1880276,1779084,1658786,1526178,1364950,1180406,1003975,816414,598277,336458)
smoothsp = smooth.spline(x,y,spar=0.35)
plot(smoothsp,type="l",col="blue",xlab="Percentile of Gene Body (5'->3')",ylab="Number of read",xlim=c(0,100))
dev.state = dev.off()