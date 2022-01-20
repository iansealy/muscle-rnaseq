#!/bin/bash

#SBATCH -J reference
#SBATCH --chdir=/rds/user/is460/hpc-work/muscle-rnaseq/reference
#SBATCH --output=%x.%a.%j.o
#SBATCH --error=%x.%a.%j.e
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --time=02:00:00
#SBATCH --mail-type=FAIL
#SBATCH -A BUSCH-NENTWICH-SL3-CPU
#SBATCH --mem=33800
#SBATCH -p cclake,icelake

cd /rds/user/is460/hpc-work/muscle-rnaseq/reference

. /etc/profile.d/modules.sh
module purge
if [ "$SLURM_JOB_PARTITION" == "cclake" ]; then
  module load rhel7/default-ccl
fi
if [ "$SLURM_JOB_PARTITION" == "icelake" ]; then
  module load rhel8/default-icl
fi
module load STAR/2.7.3a

CMD="wget ftp://ftp.ensembl.org/pub/release-105/fasta/danio_rerio/dna/Danio_rerio.GRCz11.dna_sm.primary_assembly.fa.gz \
&& wget ftp://ftp.ensembl.org/pub/release-105/gtf/danio_rerio/Danio_rerio.GRCz11.105.gtf.gz \
&& gunzip Danio_rerio.GRCz11.dna_sm.primary_assembly.fa.gz \
&& gunzip Danio_rerio.GRCz11.105.gtf.gz \
&& mkdir grcz11 \
&& STAR \
--outFileNamePrefix grcz11. \
--runThreadN 4 \
--runMode genomeGenerate \
--genomeDir grcz11 \
--genomeFastaFiles Danio_rerio.GRCz11.dna_sm.primary_assembly.fa \
--sjdbGTFfile Danio_rerio.GRCz11.105.gtf \
--sjdbOverhang 149"

JOBID=$SLURM_JOB_ID
echo -e "JobID: $JOBID\n======"
echo "TaskID: $SLURM_ARRAY_TASK_ID"
echo "Time: `date`"
echo "Running on master node: `hostname`"
echo "Current directory: `pwd`"
if [ "$SLURM_JOB_NODELIST" ]; then
        export NODEFILE=`generate_pbs_nodefile`
        cat $NODEFILE | uniq > $SLURM_JOB_NAME.machine.file.$JOBID
        echo -e "\nNodes allocated:\n================"
        echo `cat $SLURM_JOB_NAME.machine.file.$JOBID | sed -e 's/\..*$//g'`
fi
echo -e "\nExecuting command:\n==================\n$CMD\n==================\n"

eval $CMD
