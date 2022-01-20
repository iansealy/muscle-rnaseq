#!/usr/bin/env bash

bams=`cut -f1 samples.tsv | awk '{ print "../star2/" $1 "/Aligned.out.bam" }' | tr '\n' ' '`
labels=`cut -f1 samples.tsv | tr '\n' ' '`

ezBAMQC -i $bams -r ../reference/Danio_rerio.GRCz11.105.gtf --rRNA ../reference/Danio_rerio.GRCz11.105.rRNA.bed --stranded reverse -l $labels -o output -t 56
