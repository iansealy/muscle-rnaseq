#!/usr/bin/env bash

line=`sed "${1}q;d" samples.tsv`
sample=`echo $line | awk '{ print $1 }'`
samtools index $sample/Aligned.sortedByCoord.out.bam
