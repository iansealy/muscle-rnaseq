png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_wt_1.clipping_profile.png",width=500,height=500,units="px")
read_pos=c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149)
count=c(3740506,2746642,2230542,2110725,2003446,1917457,1834670,1756155,1680581,1608902,1543642,1482102,1421248,1362701,1305003,1250842,1198089,1147889,1099052,1052644,1007358,963305,920995,879801,840365,801927,765728,730162,695892,662833,630746,600222,570707,542196,514630,488371,463215,439172,416600,394964,373962,353957,334254,315747,298002,281484,265945,250893,236542,223595,211312,201046,192646,184396,176619,168997,161685,154611,148036,141593,135262,129326,123726,118580,113690,108721,104177,100005,96429,93008,90412,88037,86211,84750,83501,82796,82629,82628,83162,84066,85660,88311,91021,94249,97837,101627,105991,110374,115027,120200,125538,131429,137361,143529,149903,156477,163169,170230,177657,186984,198095,210211,223816,237894,252918,268455,285283,302384,320852,339950,359756,380438,401827,424543,448545,473207,498597,525242,552738,581460,611912,642276,674119,706857,740387,775196,811326,848854,887851,927980,969954,1012541,1057565,1103698,1151811,1201349,1253554,1306221,1361235,1416735,1475167,1539335,1608230,1679106,1755911,1837115,1941089,2058466,2570086,3564375)
plot(read_pos,1-(count/36735300),pch=20,xlab="Position of reads",ylab="Mappability",col="blue")
dev.state=dev.off()