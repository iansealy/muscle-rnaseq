#!/usr/bin/env bash

line=`sed "${1}q;d" samples.tsv`
sample=`echo $line | awk '{ print $1 }'`
samtools view -o $sample.ttn.1.bam ../star2/$sample/Aligned.sortedByCoord.out.bam 9:42732992-42873700
samtools index $sample.ttn.1.bam
