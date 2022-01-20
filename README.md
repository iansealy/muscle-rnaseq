# Muscle RNA-seq

Samples: https://docs.google.com/spreadsheets/d/1OGbNZQvTft5LoUK4C33PGkIz2bQBNeurtJhhSFDMvbI/

Sequencing 18 pools of 3 zebrafish embryos with muscle mutations. 4 condition with 6 replicates for each. The conditions are:

- srpk3_hom_ttnb_het
- srpk3_hom_ttnb_wt
- srpk3_wt_ttnb_het
- srpk3_wt_ttnb_wt

Mutations are:

- sa18907 / srpk3 (GRCz11:8:8336586 T->C)
- sa5562 / ttnb (GRCz11:9:42861631 T->G)

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
for comp in srpk3_hom_ttnb_het:srpk3_hom_ttnb_wt srpk3_wt_ttnb_het:srpk3_wt_ttnb_wt srpk3_hom_ttnb_het:srpk3_wt_ttnb_het srpk3_hom_ttnb_wt:srpk3_wt_ttnb_wt; do
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
srpk3_hom_ttnb_wt vs srpk3_wt_ttnb_wt   572
srpk3_wt_ttnb_het vs srpk3_wt_ttnb_wt   128
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

Only get genotypes for srpk3:

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

## Archive

```
module load rclone/1.51.0
rclone copy --progress $basedir/ drive-cam-muscle-rnaseq:
rclone check --progress $basedir/ drive-cam-muscle-rnaseq:
module unload rclone/1.51.0
```
