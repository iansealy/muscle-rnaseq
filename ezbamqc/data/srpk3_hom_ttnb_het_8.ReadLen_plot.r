png("/rds/user/is460/hpc-work/muscle-rnaseq/ezbamqc/output/figs/srpk3_hom_ttnb_het_8.readlen_profile.png",width=500,height=500,units="px")
readlen_val=c(48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150)
readlen_count=c(44,87,210,323,412,627,777,855,1016,1117,1411,1639,1710,1871,2081,2190,2551,2746,3338,3779,4245,4620,6244,6519,7141,8285,7832,8161,8702,9166,8870,9316,9317,9903,9761,9908,10102,10280,10446,10682,10628,11196,10708,10886,11624,11349,11532,11561,11858,11846,12250,16636,20573,21542,24103,25223,27028,27910,29634,30266,32394,33778,34868,36707,37426,39372,40692,42605,43988,45199,46893,48532,50819,51799,53763,55109,56411,57715,61225,62265,64856,68485,68345,70254,72885,74855,77420,80771,85093,85203,90335,91416,99046,106853,116049,120592,137957,142806,187421,238845,802676,1565611,21108139)
plot(readlen_val,(readlen_count/28321706),pch=20,xlab="Mapped Read Length",ylab="Proportion",col="blue")
dev.state=dev.off()