#!/usr/bin/env bash

line=`sed "${1}q;d" samples.tsv`
sample=`echo $line | awk '{ print $1 }'`
samtools view -b -o $sample.chr.bam ../star2/$sample/Aligned.sortedByCoord.out.bam `seq 25`
