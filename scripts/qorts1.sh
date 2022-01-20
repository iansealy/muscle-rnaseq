#!/usr/bin/env bash

line=`sed "${1}q;d" samples.tsv`
sample=`echo $line | awk '{ print $1 }'`
condition=`echo $line | awk '{ print $2 }'`
reads=`echo $line | awk '{ print $3 }'`
mkdir $sample
qorts QC \
--stranded \
--chromSizes chr-sizes.tsv \
--genomeFA ../reference/Danio_rerio.GRCz11.dna_sm.primary_assembly.fa \
--seqReadCt $reads \
--title $sample \
$sample.chr.bam \
Danio_rerio.GRCz11.105.chr.gtf \
$sample
