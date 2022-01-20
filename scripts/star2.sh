#!/usr/bin/env bash

line=`sed "${1}q;d" fastq.tsv`
sample=`echo $line | awk '{ print $1 }'`
fastq1=`echo $line | awk '{ print $2 }'`
fastq2=`echo $line | awk '{ print $3 }'`
mkdir $sample
STAR \
--runThreadN 4 \
--genomeDir ../reference/grcz11 \
--readFilesIn $fastq1 $fastq2 \
--readFilesCommand zcat \
--outFileNamePrefix $sample/ \
--quantMode GeneCounts \
--outSAMtype BAM Unsorted SortedByCoordinate \
--sjdbFileChrStartEnd `find ../star1 | grep SJ.out.tab$ | sort | tr '\n' ' '`
