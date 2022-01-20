#!/usr/bin/env bash

line=`sed "${1}q;d" samples.tsv`
sample=`echo $line | awk '{ print $1 }'`
bamCoverage -b ../star2/$sample/Aligned.sortedByCoord.out.bam -o $sample.bw
