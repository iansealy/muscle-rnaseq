# Muscle RNA-seq

Samples: https://docs.google.com/spreadsheets/d/1OGbNZQvTft5LoUK4C33PGkIz2bQBNeurtJhhSFDMvbI/

Sequencing 18 pools of 3 zebrafish embryos with muscle mutations. 4 condition with 6 replicates for each. The conditions are:

- srpk3_hom_ttnb_het
- srpk3_hom_ttnb_wt
- srpk3_wt_ttnb_het
- srpk3_wt_ttnb_wt

Mutations are:

- sa18907 / srpk3 (GRCz11:8:8336586 T->C) https://zmp.buschlab.org/gene/ENSDARG00000005916#sa18907
- sa5562 / ttnb (GRCz11:9:42861631 T->G) https://zmp.buschlab.org/gene/ENSDARG00000091908#sa5562

ttnb is now ENSDARG00000000563 / ttn.1

Samples went to CSCI for QC and library making on 2021-12-09

QC done on 2021-12-12 and samples chosen for library making on 2021-12-13

Libraries went to CRUK for sequencing on 2021-12-21

Sequencing returned on 2022-01-18

CSCI ticket: https://genomics-sci.atlassian.net/servicedesk/customer/portal/1/GR-279

## Environment variables

```
gitdir=$HOME/checkouts/muscle-rnaseq
basedir=/rds/user/$USER/hpc-work/muscle-rnaseq
webhost='buschlab@buschlab.org'
webpath=temp.buschlab.org/muscle-rnaseq
```

## Set up site to view data

http://temp.buschlab.org/muscle-rnaseq/

```
ssh $webhost mkdir $webpath
```

## Create directories

```
mkdir -p $basedir $gitdir/sbatch $gitdir/seff $gitdir/scripts
```

## Download and index reference

```
mkdir -p $basedir/reference $gitdir/reference

sbatch $gitdir/sbatch/reference.sbatch

process-seff $basedir/reference/reference
cp $basedir/*/*.seff* $gitdir/seff

cp $basedir/reference/grcz11/genomeParameters.txt $basedir/reference/grcz11.Log.out $gitdir/reference
```

## Download sequencing data

```
mkdir -p $basedir/sequence 

lftp -e "mget -O $basedir/sequence SLX-21419*" -u stem_paramor,redcause72 ftp1.cruk.cam.ac.uk

cd $basedir/sequence
md5sum --quiet -c *.md5sums.txt

module load rclone/1.51.0
rclone copy --progress $basedir/ drive-cam-muscle-rnaseq:
rclone check --progress $basedir/ drive-cam-muscle-rnaseq:
module unload rclone/1.51.0
```

## FastQC

```
mkdir -p $basedir/fastq
cp $basedir/sequence/*.fq.gz $basedir/fastq

sbatch $gitdir/sbatch/fastqc.sbatch

process-seff $basedir/fastq/fastqc
cp $basedir/*/*.seff* $gitdir/seff
```

## MultiQC

```
module load MultiQC/1.8
find $basedir/fastq -name *fastqc.zip | sort -V > $basedir/fastq/multiqc-input.txt
multiqc --file-list $basedir/fastq/multiqc-input.txt -m fastqc -o $basedir/fastq -n multiqc_report.html
module unload MultiQC/1.8

mkdir -p $gitdir/fastq
cp $basedir/fastq/multiqc_report.html $gitdir/fastq

ssh $webhost mkdir $webpath/fastq
scp $basedir/fastq/multiqc_report.html $webhost:$webpath/fastq
ssh $webhost chmod o+r $webpath/fastq/*
```

View http://temp.buschlab.org/muscle-rnaseq/fastq/multiqc_report.html

All samples look OK

- %Dups ranges from 32.8-58.6%
- %GC ranges from 46-47%
- M Seqs from 13.8-28.8
- 22.7 M read pairs lost because can't be demultiplexed

## Align FASTQ files with STAR

```
mkdir -p $basedir/star1

join -t $'\t' -1 2 -2 1 $gitdir/barcode-well.tsv $gitdir/well-sample.tsv > $gitdir/well-barcode-sample.tsv

cat $gitdir/well-barcode-sample.tsv | while read line; do
  barcode=`echo "$line" | awk '{ print $2 }'`
  sample=`echo "$line" | awk '{ print $3 }'`
  fastq1="$basedir/fastq/SLX-21419.$barcode.HV2TTDRXY.s_2.r_1.fq.gz"
  fastq2="$basedir/fastq/SLX-21419.$barcode.HV2TTDRXY.s_2.r_2.fq.gz"
  echo -e "$sample\t$fastq1\t$fastq2"
done > $gitdir/fastq.tsv

cp $gitdir/fastq.tsv $gitdir/scripts/star1.sh $basedir/star1

sbatch $gitdir/sbatch/star1.sbatch

process-seff $basedir/star1/star1
cp $basedir/*/*.seff* $gitdir/seff
```

## Align FASTQ files with STAR again

```
mkdir -p $basedir/star2

cp $gitdir/fastq.tsv $gitdir/scripts/star2.sh $basedir/star2

sbatch $gitdir/sbatch/star2.sbatch

process-seff $basedir/star2/star2
cp $basedir/*/*.seff* $gitdir/seff
```

## Get Ensembl 105 annotation

```
mkdir -p $basedir/annotation

sbatch $gitdir/sbatch/annotation.sbatch

process-seff $basedir/annotation/annotation
cp $basedir/*/*.seff* $gitdir/seff
```

## Make samples file

```
cut -f2 $gitdir/well-sample.tsv | awk '{ print $1 "\t" $1 }' | sed -e 's/_[0-9]*$//' | sort -V > $gitdir/samples.tsv
```

## Index BAM files

```
cp $gitdir/samples.tsv $gitdir/scripts/indexbam.sh $basedir/star2

sbatch $gitdir/sbatch/indexbam.sbatch

process-seff $basedir/star2/indexbam
cp $basedir/*/*.seff* $gitdir/seff
```

## Convert BAM to bigWig

```
mkdir -p $basedir/bigwig

cp $gitdir/samples.tsv $gitdir/scripts/bigwig.sh $basedir/bigwig

sbatch $gitdir/sbatch/bigwig.sbatch

process-seff $basedir/bigwig/bigwig
cp $basedir/*/*.seff* $gitdir/seff

ssh $webhost mkdir $webpath/bigwig
scp $basedir/bigwig/*.bw $webhost:$webpath/bigwig
```

## Run ezBAMQC

Get BED file of rRNA genes

```
module load BEDOPS/2.4.37
grep 'gene_biotype "rRNA"' $basedir/reference/Danio_rerio.GRCz11.105.gtf | awk '{ if ($3 == "gene") print $0 }' \
| awk '{ if ($0 ~ "transcript_id") print $0; else print $0 " transcript_id \"\";" }' | gtf2bed \
> $basedir/reference/Danio_rerio.GRCz11.105.rRNA.bed
module unload BEDOPS/2.4.37
```

```
mkdir -p $gitdir/ezbamqc $basedir/ezbamqc

cp $gitdir/samples.tsv $gitdir/scripts/ezbamqc.sh $basedir/ezbamqc

sbatch $gitdir/sbatch/ezbamqc.sbatch

process-seff $basedir/ezbamqc/ezbamqc
cp $basedir/*/*.seff* $gitdir/seff

perl -spi -e 's/smp_inner.png/smp_inner_dist.png/' $basedir/ezbamqc/output/ezBAMQC_output.html
cp -r $basedir/ezbamqc/output/* $gitdir/ezbamqc
scp -r $basedir/ezbamqc/output $webhost:$webpath/ezbamqc
```

View http://temp.buschlab.org/muscle-rnaseq/ezbamqc/ezBAMQC_output.html

## Run QoRTs

```
mkdir -p $basedir/qorts $gitdir/qorts

cat $gitdir/samples.tsv | while read line; do
  sample=`echo "$line" | awk '{ print $1 }'`
  group=`echo "$line" | awk '{ print $2 }' | sed -e 's/-.*//'`
  reads=`grep 'input reads' $basedir/star2/$sample/Log.final.out | awk '{ print $6 }'`
  echo -e "$sample\t$group\t$reads"
done > $gitdir/qorts/samples.tsv
cp $gitdir/qorts/samples.tsv $basedir/qorts
```

Make chromosome-only annotation and BAM files:

```
grep -E '^[0-9]+\b' $basedir/reference/grcz11/chrNameLength.txt > $basedir/qorts/chr-sizes.tsv
grep '^[#0-9]' $basedir/reference/Danio_rerio.GRCz11.105.gtf > $basedir/qorts/Danio_rerio.GRCz11.105.chr.gtf
cp $gitdir/scripts/samtools.sh $basedir/qorts

sbatch $gitdir/sbatch/samtools.sbatch

process-seff $basedir/qorts/samtools
cp $basedir/*/*.seff* $gitdir/seff
```

```
cp $gitdir/scripts/qorts1.sh $basedir/qorts

sbatch $gitdir/sbatch/qorts1.sbatch

process-seff $basedir/qorts/qorts1
cp $basedir/*/*.seff* $gitdir/seff
```

```
echo -e "unique.ID\tgroup.ID" > $basedir/qorts/decoder.tsv
cut -f1-2 $basedir/qorts/samples.tsv | sort >> $basedir/qorts/decoder.tsv
cp $gitdir/scripts/qorts2.R $basedir/qorts
mkdir -p $basedir/qorts/output

sbatch $gitdir/sbatch/qorts2.sbatch

process-seff $basedir/qorts/qorts2
cp $basedir/*/*.seff* $gitdir/seff

cp $basedir/qorts/output/* $gitdir/qorts

ssh $webhost mkdir $webpath/qorts
scp $basedir/qorts/output/*.pdf $webhost:$webpath/qorts
ssh $webhost chmod o+r $webpath/qorts/*
```

View http://temp.buschlab.org/muscle-rnaseq/qorts/

## QC

RINSs listed in `qc-samples.tsv`.

Compare RINs and degradation on gene-body coverage plots:

```
cp $gitdir/qc-samples.tsv $gitdir/qc-samples-orig.tsv
cat $gitdir/qc-samples.tsv | while read line; do
  sample=`echo "$line" | awk '{ print $1}'`
  echo -ne "$line\t"
  gzip -cd $basedir/qorts/$sample/QC.geneBodyCoverage.byExpr.avgPct.txt.gz | grep '^0.8\b' | cut -f4
done > $gitdir/qc-samples.tsv.tmp
mv $gitdir/qc-samples.tsv.tmp $gitdir/qc-samples.tsv

module load $HOME/privatemodules/R/4.0.3
cd $gitdir
Rscript scripts/plot-qc-samples.R
module unload $HOME/privatemodules/R/4.0.3

scp -r $gitdir/qc-samples.pdf $webhost:$webpath
```

View http://temp.buschlab.org/muscle-rnaseq/qc-samples.pdf

- srpk3_wt_ttnb_het_7 is an outlier according to QoRTs gene-body coverage plots

## Run DESeq2

```
mkdir -p $basedir/deseq2
cp $gitdir/scripts/deseq2.R $gitdir/scripts/deseq2.sh $basedir/deseq2
mkdir -p $basedir/deseq2-all
cp $gitdir/samples.tsv $basedir/deseq2-all
echo "Rscript deseq2.R -s $basedir/deseq2-all/samples.tsv \
-e srpk3_hom_ttnb_het,srpk3_hom_ttnb_wt \
-c srpk3_wt_ttnb_het,srpk3_wt_ttnb_wt \
-a $basedir/annotation/annotation.txt -d $basedir/star2 -o $basedir/deseq2-all" > $basedir/deseq2/deseq2.txt
for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_wt; do
  e=`echo "$comp" | awk -F':' '{ print $1 }'`
  c=`echo "$comp" | awk -F':' '{ print $2 }'`
  mkdir -p $basedir/deseq2-${e}_vs_$c
  grep -E "$e|$c" $gitdir/samples.tsv > $basedir/deseq2-${e}_vs_$c/samples.tsv
  echo "Rscript deseq2.R -s $basedir/deseq2-${e}_vs_$c/samples.tsv -e $e -c $c -a $basedir/annotation/annotation.txt -d $basedir/star2 -o $basedir/deseq2-${e}_vs_$c" >> $basedir/deseq2/deseq2.txt
done

sbatch $gitdir/sbatch/deseq2.sbatch

process-seff $basedir/deseq2/deseq2
cp $basedir/*/*.seff* $gitdir/seff

cp -r $basedir/deseq2-* $gitdir

scp -r $basedir/deseq2-* $webhost:$webpath
```

- srpk3_hom_ttnb_het and srpk3_hom_ttnb_wt don't separate brilliantly by PCA


Number of significant genes for each experiment:

```
grep -c ^ENS $basedir/deseq2-*/sig.tsv | sed -e 's/\/sig.tsv:/\t/' | sed -e 's/.*\/deseq2-//' | grep -v all | sed -e 's/_vs_/ vs /'
```

```
srpk3_hom_ttnb_het vs srpk3_hom_ttnb_wt 15
srpk3_hom_ttnb_het vs srpk3_wt_ttnb_het 246
srpk3_hom_ttnb_het vs srpk3_wt_ttnb_wt  794
srpk3_hom_ttnb_wt vs srpk3_wt_ttnb_wt   572
srpk3_wt_ttnb_het vs srpk3_wt_ttnb_wt   128
```

## Make count plots

```
cp $gitdir/scripts/countplots.R $gitdir/scripts/countplots.sh $basedir/deseq2
for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_wt; do
  e=`echo "$comp" | awk -F':' '{ print $1 }'`
  c=`echo "$comp" | awk -F':' '{ print $2 }'`
  echo "Rscript countplots.R -s $basedir/deseq2-all/samples.tsv -o $basedir/deseq2-${e}_vs_$c --all $basedir/deseq2-all/all.tsv --sig $basedir/deseq2-${e}_vs_$c/sig.tsv" >> $basedir/deseq2/countplots.txt
done

sbatch $gitdir/sbatch/countplots.sbatch

process-seff $basedir/deseq2/countplots
cp $basedir/*/*.seff* $gitdir/seff

rsync -va $basedir/deseq2-* $gitdir/
rsync -vaz $basedir/deseq2-* $webhost:$webpath/
```

## Run ZFA enrichment

```
mkdir -p $basedir/zfa
cp $gitdir/scripts/zfa.sh $basedir/zfa
for dir in `find $basedir/deseq2-* -maxdepth 0`; do
  echo "cd $dir; zfa sig.tsv all.tsv; rm table-tmp.sig-Parent-Child-Union-Bonferroni.txt"
done > $basedir/zfa/zfa.txt

sbatch $gitdir/sbatch/zfa.sbatch

process-seff $basedir/zfa/zfa
cp $basedir/*/*.seff* $gitdir/seff

rsync -va $basedir/deseq2-* $gitdir/
rsync -vaz $basedir/deseq2-* $webhost:$webpath/
```

## Run topGO

```
mkdir -p $basedir/topgo
cp $gitdir/scripts/topgo.sh $basedir/topgo
find $basedir/deseq2-* -maxdepth 0 > $basedir/topgo/topgo.txt

sbatch $gitdir/sbatch/topgo.sbatch

process-seff $basedir/topgo/topgo
cp $basedir/*/*.seff* $gitdir/seff

rsync -va --include "*/"  --include="*.tsv" --include="*.pdf" --exclude="*" $basedir/deseq2-* $gitdir/
rsync -vaz --include "*/"  --include="*.tsv" --include="*.pdf" --exclude="*" $basedir/deseq2-* $webhost:$webpath/
```

## Check genotypes

```
mkdir $basedir/genotyping
module load bcftools/1.11
bcftools mpileup -Ou --max-depth 10000 --annotate FORMAT/AD -r 8:8336586-8336586,9:42861631-42861631 \
-f $basedir/reference/Danio_rerio.GRCz11.dna_sm.primary_assembly.fa $basedir/star2/*/Aligned.sortedByCoord.out.bam \
| bcftools call -mv -Oz -o $basedir/genotyping/calls.vcf.gz
module unload bcftools/1.11
```

Only get genotypes for srpk3

```
gzip -cd $basedir/genotyping/calls.vcf.gz | tail -2 \
| python -c "import sys; print('\n'.join(' '.join(c) for c in zip(*(l.split() for l in sys.stdin.readlines() if l.strip()))))" \
| grep star | sed -e 's/.*star2.//' | sed -e 's/.Aligned.sortedByCoord.out.bam//' | sed -e 's/:.*:/ /' | column -t
```

```
srpk3_hom_ttnb_het_1   1/1  0,27
srpk3_hom_ttnb_het_10  1/1  0,39
srpk3_hom_ttnb_het_2   1/1  0,41
srpk3_hom_ttnb_het_7   1/1  0,39
srpk3_hom_ttnb_het_8   1/1  0,18
srpk3_hom_ttnb_het_9   1/1  0,35
srpk3_hom_ttnb_wt_1    1/1  0,42
srpk3_hom_ttnb_wt_4    1/1  0,30
srpk3_hom_ttnb_wt_5    1/1  0,33
srpk3_hom_ttnb_wt_6    1/1  0,59
srpk3_hom_ttnb_wt_7    1/1  0,35
srpk3_hom_ttnb_wt_8    1/1  0,34
srpk3_wt_ttnb_het_1    ./.  0,0
srpk3_wt_ttnb_het_2    0/1  2,0
srpk3_wt_ttnb_het_3    0/1  1,0
srpk3_wt_ttnb_het_7    ./.  0,0
srpk3_wt_ttnb_het_8    0/1  1,0
srpk3_wt_ttnb_het_9    ./.  0,0
srpk3_wt_ttnb_wt_2     ./.  0,0
srpk3_wt_ttnb_wt_3     ./.  0,0
srpk3_wt_ttnb_wt_4     ./.  0,0
srpk3_wt_ttnb_wt_5     0/1  2,0
srpk3_wt_ttnb_wt_6     0/1  2,0
srpk3_wt_ttnb_wt_7     0/0  3,0
```

- All srpk3_hom_* samples are clearly homs
- Read depth for srpk3_wt is very low, but no ALT reads found

On count plot for ENSDARG00000005916 / srpk3, wt samples are lower than hom, but not zero:

https://temp.buschlab.org/muscle-rnaseq/deseq2-all/counts.pdf

Consistent with essential splice site mutation

On count plot for ENSDARG00000000563 / ttn.1, het samples are lower than wt, but not zero:

https://temp.buschlab.org/muscle-rnaseq/deseq2-srpk3_hom_ttnb_het_vs_srpk3_hom_ttnb_wt/counts.pdf

Check genotypes for srpk3:

```
module load samtools/1.11
for sample in `cut -f1 $gitdir/samples.tsv`; do
  echo -ne "$sample\t"
  samtools tview --reference $basedir/reference/Danio_rerio.GRCz11.dna_sm.primary_assembly.fa -d T -p 8:8336586 $basedir/star2/$sample/Aligned.sortedByCoord.out.bam \
| tail -n +4 | cut -c1 | grep -v '^ ' | sort | uniq -c | tr '\n' ' '
  echo
done
module unload samtools/1.11
```

```
srpk3_hom_ttnb_het_1          6 <       4 >      14 C      19 c 
srpk3_hom_ttnb_het_2          7 <       6 >      35 C      18 c 
srpk3_hom_ttnb_het_7          8 <       6 >      26 C      25 c 
srpk3_hom_ttnb_het_8          6 <       3 >      14 C      11 c 
srpk3_hom_ttnb_het_9          7 <       3 >      26 C      16 c 
srpk3_hom_ttnb_het_10        10 <       4 >      26 C      26 c 
srpk3_hom_ttnb_wt_1           9 <       9 >      25 C      28 c 
srpk3_hom_ttnb_wt_4          12 <       5 >      22 C      13 c 
srpk3_hom_ttnb_wt_5           9 <       2 >      29 C      14 c 
srpk3_hom_ttnb_wt_6          15 <      18 >       1 A      30 C      39 c 
srpk3_hom_ttnb_wt_7           8 <       3 >      17 C      24 c 
srpk3_hom_ttnb_wt_8          10 <       5 >      27 C       1 G      20 c 
srpk3_wt_ttnb_het_1          22 <      25 > 
srpk3_wt_ttnb_het_2           2 .      17 <      20 > 
srpk3_wt_ttnb_het_3           1 .      26 <      10 > 
srpk3_wt_ttnb_het_7          36 <      32 > 
srpk3_wt_ttnb_het_8           1 .      31 <      29 > 
srpk3_wt_ttnb_het_9          45 <      47 > 
srpk3_wt_ttnb_wt_2           19 <      28 > 
srpk3_wt_ttnb_wt_3           25 <      28 > 
srpk3_wt_ttnb_wt_4           37 <      33 > 
srpk3_wt_ttnb_wt_5            1 ,       1 .      32 <      21 > 
srpk3_wt_ttnb_wt_6            2 .      38 <      34 > 
srpk3_wt_ttnb_wt_7            1 ,       4 .      42 <      36 > 
```

Check genotypes for ttnb:

```
module load samtools/1.11
for sample in `cut -f1 $gitdir/samples.tsv`; do
  echo -ne "$sample\t"
  samtools tview --reference $basedir/reference/Danio_rerio.GRCz11.dna_sm.primary_assembly.fa -d T -p 9:42861631 $basedir/star2/$sample/Aligned.sortedByCoord.out.bam \
| tail -n +4 | cut -c1 | grep -v '^ ' | sort | uniq -c | tr '\n' ' '
  echo
done
module unload samtools/1.11
```

```
srpk3_hom_ttnb_het_1          3 <
srpk3_hom_ttnb_het_2          2 <       7 >       1 c
srpk3_hom_ttnb_het_7          2 ,       1 .       7 <       7 >
srpk3_hom_ttnb_het_8          1 <       8 >
srpk3_hom_ttnb_het_9          3 <       5 >
srpk3_hom_ttnb_het_10         1 ,       4 <      12 >
srpk3_hom_ttnb_wt_1           4 <       1 >
srpk3_hom_ttnb_wt_4           2 ,       5 <       2 >
srpk3_hom_ttnb_wt_5           2 <       3 >
srpk3_hom_ttnb_wt_6           2 <       8 >
srpk3_hom_ttnb_wt_7          11 <       4 >
srpk3_hom_ttnb_wt_8           2 <       6 >
srpk3_wt_ttnb_het_1           3 <       3 >
srpk3_wt_ttnb_het_2           2 <       7 >
srpk3_wt_ttnb_het_3           2 <      10 >
srpk3_wt_ttnb_het_7           1 ,       6 <       7 >
srpk3_wt_ttnb_het_8           5 <      12 >
srpk3_wt_ttnb_het_9           2 <       3 >
srpk3_wt_ttnb_wt_2            7 <       4 >
srpk3_wt_ttnb_wt_3            2 <      10 >
srpk3_wt_ttnb_wt_4            7 <      12 >
srpk3_wt_ttnb_wt_5           12 <       7 >
srpk3_wt_ttnb_wt_6            1 ,      10 <       8 >
srpk3_wt_ttnb_wt_7            7 <       7 >
```

## Archive

```
module load rclone/1.51.0
rclone sync --progress $basedir/ drive-cam-muscle-rnaseq:
rclone check --progress $basedir/ drive-cam-muscle-rnaseq:
module unload rclone/1.51.0
```

## Run rMATS

```
mkdir -p $basedir/rmats

for sample in `cut -f1 $gitdir/samples.tsv`; do
  mkdir $basedir/rmats/$sample
  echo "$basedir/star2/$sample/Aligned.sortedByCoord.out.bam" > $basedir/rmats/$sample/prep.txt
  echo -n "rmats.py --gtf ../reference/Danio_rerio.GRCz11.105.gtf --b1 $basedir/rmats/$sample/prep.txt "
  echo -n "--od $basedir/rmats/$sample --tmp $basedir/rmats/$sample "
  echo "-t paired --libType fr-firststrand --readLength 150 --variable-read-length --task prep --novelSS --allow-clipping"
done > $basedir/rmats/prep.txt

sbatch $gitdir/sbatch/rmatsprep.sbatch

process-seff $basedir/rmats/rmatsprep
cp $basedir/*/*.seff* $gitdir/seff

for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_wt; do
  e=`echo "$comp" | awk -F':' '{ print $1 }'`
  c=`echo "$comp" | awk -F':' '{ print $2 }'`
  mkdir -p $basedir/rmats-${e}_vs_$c/tmp
  for sample in `grep "$e" $gitdir/samples.tsv | cut -f1`; do
    cp $basedir/rmats/$sample/*.rmats $basedir/rmats-${e}_vs_$c/tmp/$sample.rmats
    echo "$basedir/star2/$sample/Aligned.sortedByCoord.out.bam"
  done | tr '\n' ',' | sed -e 's/,$//' > $basedir/rmats-${e}_vs_$c/b1.txt
  for sample in `grep "$c" $gitdir/samples.tsv | cut -f1`; do
    cp $basedir/rmats/$sample/*.rmats $basedir/rmats-${e}_vs_$c/tmp/$sample.rmats
    echo "$basedir/star2/$sample/Aligned.sortedByCoord.out.bam"
  done | tr '\n' ',' | sed -e 's/,$//' > $basedir/rmats-${e}_vs_$c/b2.txt
  echo -n "rmats.py --gtf ../reference/Danio_rerio.GRCz11.105.gtf --b1 $basedir/rmats-${e}_vs_$c/b1.txt --b2 $basedir/rmats-${e}_vs_$c/b2.txt "
  echo -n "--od $basedir/rmats-${e}_vs_$c --tmp $basedir/rmats-${e}_vs_$c/tmp "
  echo "-t paired --libType fr-firststrand --readLength 150 --variable-read-length --task post --novelSS --allow-clipping"
done > $basedir/rmats/post.txt

sbatch $gitdir/sbatch/rmatspost.sbatch

process-seff $basedir/rmats/rmatspost
cp $basedir/*/*.seff* $gitdir/seff

for comp in `ls -d $basedir/rmats-* | sed -e 's/.*\///'`; do
  mkdir $gitdir/$comp
  cp $basedir/$comp/*.txt $gitdir/$comp
done

scp -r $gitdir/rmats-* $webhost:$webpath
```

## Run rMATS on random groups of samples

```
for comp in `seq 10`; do
  mkdir -p $basedir/rmats-random-$comp/tmp
  sort -R $gitdir/samples.tsv | cut -f1 > $basedir/rmats-random-$comp/tmp/samples.tsv
  for sample in `head -6 $basedir/rmats-random-$comp/tmp/samples.tsv`; do
    cp $basedir/rmats/$sample/*.rmats $basedir/rmats-random-$comp/tmp/$sample.rmats
    echo "$basedir/star2/$sample/Aligned.sortedByCoord.out.bam"
  done | tr '\n' ',' | sed -e 's/,$//' > $basedir/rmats-random-$comp/b1.txt
  for sample in `tail -6 $basedir/rmats-random-$comp/tmp/samples.tsv`; do
    cp $basedir/rmats/$sample/*.rmats $basedir/rmats-random-$comp/tmp/$sample.rmats
    echo "$basedir/star2/$sample/Aligned.sortedByCoord.out.bam"
  done | tr '\n' ',' | sed -e 's/,$//' > $basedir/rmats-random-$comp/b2.txt
  echo -n "rmats.py --gtf ../reference/Danio_rerio.GRCz11.105.gtf --b1 $basedir/rmats-random-$comp/b1.txt --b2 $basedir/rmats-random-$comp/b2.txt "
  echo -n "--od $basedir/rmats-random-$comp --tmp $basedir/rmats-random-$comp/tmp "
  echo "-t paired --libType fr-firststrand --readLength 150 --variable-read-length --task post --novelSS --allow-clipping"
done > $basedir/rmats/random.txt

sbatch $gitdir/sbatch/rmatsrandom.sbatch

process-seff $basedir/rmats/rmatsrandom
cp $basedir/*/*.seff* $gitdir/seff
```

## Plot SignificantEventsJC from rMATS

```
echo -e "Comparison\tEvent\tSig\tType" > $gitdir/rmats.tsv
for comp in `ls -d $basedir/rmats-* | sed -e 's/.*rmats-//'`; do
  cut -f1,4 $basedir/rmats-$comp/summary.txt | tail -n +2 | awk "{ print \"$comp\\t\" \$0 }"
done | awk '{ if ($1 ~ /random/) { print $0 "\trandom" } else { print $0 "\texpt" } }' \
| sort -V >> $gitdir/rmats.tsv

cd $gitdir
module load $HOME/privatemodules/R/4.0.3
Rscript scripts/plot-rmats.R
module unload $HOME/privatemodules/R/4.0.3

scp -r $gitdir/rmats.pdf $webhost:$webpath
```

View https://temp.buschlab.org/muscle-rnaseq/rmats.pdf

Different types of events: http://rnaseq-mats.sourceforge.net/splicing.jpg

## Reformat rMATS output

```
for comp in `ls -d $gitdir/rmats-* | sed -e 's/.*\///'`; do
  mkdir -p $gitdir/$comp/output
  mv $gitdir/$comp/*.txt $gitdir/$comp/output
  for event in A3SS A5SS MXE RI SE; do
    echo -e "Gene\tpval\tFDR\tChr\tStart\tEnd\tStrand\tBiotype\tName\tDescription" > $gitdir/$comp/$event.all.tsv
    echo -e "Gene\tpval\tFDR\tChr\tStart\tEnd\tStrand\tBiotype\tName\tDescription" > $gitdir/$comp/$event.sig.tsv
    cols="2,19,20"
    if [[ "$event" == "MXE" ]]; then
      cols="2,21,22"
    fi
    cut -f"$cols" $gitdir/$comp/output/$event.MATS.JC.txt | sed -e 's/"//g' | grep ENSDARG | sort \
      | join -j1 -t$'\t' - $basedir/annotation/annotation.txt \
      | sort -k3,3g -k2,2g -k1,1 \
      >> $gitdir/$comp/$event.all.tsv
      awk '{ if ($3 < 0.05) print $0 }' $gitdir/$comp/$event.all.tsv >> $gitdir/$comp/$event.sig.tsv
    cp $gitdir/$comp/$event.all.tsv $gitdir/$comp/$event.sig.tsv $basedir/$comp
  done
done

rsync -vaz --delete $gitdir/rmats-* $webhost:$webpath/
```

## Run ZFA enrichment

```
for dir in `find $basedir/rmats-* -maxdepth 0 | grep -v random`; do
  for event in A3SS A5SS MXE RI SE; do
    echo "cd $dir; mkdir $event; cd $event; zfa ../$event.sig.tsv ../$event.all.tsv; rm table-tmp.sig-Parent-Child-Union-Bonferroni.txt"
  done
done > $basedir/zfa/zfarmats.txt

sbatch $gitdir/sbatch/zfarmats.sbatch

process-seff $basedir/zfa/zfarmats
cp $basedir/*/*.seff* $gitdir/seff

for dir in `find $basedir/rmats-* -maxdepth 0 | grep -v random`; do
  for event in A3SS A5SS MXE RI SE; do
    mv $dir/$event/zfa.all.tsv $dir/$event.zfa.all.tsv
    mv $dir/$event/zfa.sig.tsv $dir/$event.zfa.sig.tsv
    rmdir $dir/$event
  done
  comp=`echo "$dir" | sed -e 's/.*\///'`
  cp $dir/*.zfa.sig.tsv $gitdir/$comp
done

rsync -vaz --delete $gitdir/rmats-* $webhost:$webpath/
```

## Run topGO

```
cp $gitdir/scripts/topgormats.sh $basedir/topgo
for dir in `find $basedir/rmats-* -maxdepth 0 | grep -v random`; do
  for event in A3SS A5SS MXE RI SE; do
    echo -e "$dir\t$event"
  done
done > $basedir/topgo/topgormats.txt

sbatch $gitdir/sbatch/topgormats.sbatch

process-seff $basedir/topgo/topgormats
cp $basedir/*/*.seff* $gitdir/seff

for comp in `ls -d $gitdir/rmats-* | sed -e 's/.*\///'`; do
  for event in A3SS A5SS MXE RI SE; do
    cp -r $basedir/$comp/$event.topgo $gitdir/$comp
    find $gitdir/$comp -type f | grep -vE '(tsv|pdf)$' | xargs rm
  done
done

rsync -vaz --delete $gitdir/rmats-* $webhost:$webpath/
```

## Run DESeq2 again

Rerun DESeq2 with samples grouped by PC2 from https://temp.buschlab.org/muscle-rnaseq/deseq2-all/pca.pdf which appears to show a clutch effect

Exclude srpk3_wt_ttnb_het_7 which is between groups and also a QoRTs outlier:

https://temp.buschlab.org/muscle-rnaseq/qorts/plot-sampleHL-coloredByLane-srpk3_wt_ttnb_het_7.pdf

```
cut -f1,3 deseq2-all/PCs.tsv | sort -nk2,2 | grep -vE 'Sample|srpk3_wt_ttnb_het_7' | awk '{ print $1 "\t" $2 "\t" $1 }' | sed -E 's/_[0-9]+$//' \
| awk '{ if ($2 < 0) { print $1 "\t" $3 "\tclutch1" } else { print $1 "\t" $3 "\tclutch2" } }' | sort -V > $gitdir/samples-clutch.tsv
mkdir -p $basedir/deseq2-all-clutch
cp $gitdir/samples-clutch.tsv $basedir/deseq2-all-clutch/samples.tsv
echo "Rscript deseq2.R -s $basedir/deseq2-all-clutch/samples.tsv \
-e srpk3_hom_ttnb_het,srpk3_hom_ttnb_wt \
-c srpk3_wt_ttnb_het,srpk3_wt_ttnb_wt \
-a $basedir/annotation/annotation.txt -d $basedir/star2 -o $basedir/deseq2-all-clutch" > $basedir/deseq2/deseq2-clutch.txt
for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_wt; do
  e=`echo "$comp" | awk -F':' '{ print $1 }'`
  c=`echo "$comp" | awk -F':' '{ print $2 }'`
  mkdir -p $basedir/deseq2-${e}_vs_$c-clutch
  grep -E "$e|$c" $gitdir/samples-clutch.tsv > $basedir/deseq2-${e}_vs_$c-clutch/samples.tsv
  echo "Rscript deseq2.R -s $basedir/deseq2-${e}_vs_$c-clutch/samples.tsv -e $e -c $c -a $basedir/annotation/annotation.txt -d $basedir/star2 -o $basedir/deseq2-${e}_vs_$c-clutch" >> $basedir/deseq2/deseq2-clutch.txt
done

sbatch $gitdir/sbatch/deseq2-clutch.sbatch

process-seff $basedir/deseq2/deseq2-clutch
cp $basedir/*/*.seff* $gitdir/seff

cp -r $basedir/deseq2-*-clutch $gitdir

scp -r $basedir/deseq2-*-clutch $webhost:$webpath
```

Number of significant genes for each experiment:

```
grep -c ^ENS $basedir/deseq2-*-clutch/sig.tsv | sed -e 's/\/sig.tsv:/\t/' | sed -e 's/.*\/deseq2-//' | grep -v all | sed -e 's/_vs_/ vs /'
```

```
srpk3_hom_ttnb_het vs srpk3_hom_ttnb_wt-clutch  52
srpk3_hom_ttnb_het vs srpk3_wt_ttnb_het-clutch  98
srpk3_hom_ttnb_het vs srpk3_wt_ttnb_wt-clutch   397
srpk3_hom_ttnb_wt vs srpk3_wt_ttnb_wt-clutch    332
srpk3_wt_ttnb_het vs srpk3_wt_ttnb_wt-clutch    53
```

## Make count plots

```
for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_wt; do
  e=`echo "$comp" | awk -F':' '{ print $1 }'`
  c=`echo "$comp" | awk -F':' '{ print $2 }'`
  echo "Rscript countplots.R -s $basedir/deseq2-all-clutch/samples.tsv -o $basedir/deseq2-${e}_vs_$c-clutch --all $basedir/deseq2-all-clutch/all.tsv --sig $basedir/deseq2-${e}_vs_$c-clutch/sig.tsv" \
>> $basedir/deseq2/countplots-clutch.txt
done

sbatch $gitdir/sbatch/countplots-clutch.sbatch

process-seff $basedir/deseq2/countplots-clutch
cp $basedir/*/*.seff* $gitdir/seff

rsync -va $basedir/deseq2-*-clutch $gitdir/
rsync -vaz $basedir/deseq2-*-clutch $webhost:$webpath/
```

## Run ZFA enrichment

```
for dir in `find $basedir/deseq2-*-clutch -maxdepth 0`; do
  echo "cd $dir; zfa sig.tsv all.tsv; rm table-tmp.sig-Parent-Child-Union-Bonferroni.txt"
done > $basedir/zfa/zfa-clutch.txt

sbatch $gitdir/sbatch/zfa-clutch.sbatch

process-seff $basedir/zfa/zfa-clutch
cp $basedir/*/*.seff* $gitdir/seff

rsync -va $basedir/deseq2-*-clutch $gitdir/
rsync -vaz $basedir/deseq2-*-clutch $webhost:$webpath/
```

## Run topGO

```
cp $gitdir/scripts/topgo-clutch.sh $basedir/topgo
find $basedir/deseq2-*-clutch -maxdepth 0 > $basedir/topgo/topgo-clutch.txt

sbatch $gitdir/sbatch/topgo-clutch.sbatch

process-seff $basedir/topgo/topgo-clutch
cp $basedir/*/*.seff* $gitdir/seff

rsync -va --include "*/"  --include="*.tsv" --include="*.pdf" --exclude="*" $basedir/deseq2-*-clutch $gitdir/
rsync -vaz --include "*/"  --include="*.tsv" --include="*.pdf" --exclude="*" $basedir/deseq2-*-clutch $webhost:$webpath/
```

## Convert BAM to bigWig

```
mkdir -p $basedir/ttn.1

cp $gitdir/samples.tsv $gitdir/scripts/ttn.1.sh $basedir/ttn.1

sbatch $gitdir/sbatch/ttn.1.sbatch

process-seff $basedir/ttn.1/ttn.1
cp $basedir/*/*.seff* $gitdir/seff
```

## Archive

```
module load rclone/1.51.0
rclone sync --progress $basedir/ drive-cam-muscle-rnaseq:
rclone check --progress $basedir/ drive-cam-muscle-rnaseq:
module unload rclone/1.51.0
```
