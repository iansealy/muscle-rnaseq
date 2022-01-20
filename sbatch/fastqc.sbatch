#!/bin/bash

#SBATCH -J fastqc
#SBATCH --chdir=/rds/user/is460/hpc-work/muscle-rnaseq/fastq
#SBATCH --output=%x.%a.%j.o
#SBATCH --error=%x.%a.%j.e
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --time=01:00:00
#SBATCH --mail-type=FAIL
#SBATCH -A BUSCH-NENTWICH-SL3-CPU
#SBATCH -p cclake,icelake

cd /rds/user/is460/hpc-work/muscle-rnaseq/fastq

. /etc/profile.d/modules.sh
module purge
if [ "$SLURM_JOB_PARTITION" == "cclake" ]; then
  module load rhel7/default-ccl
fi
if [ "$SLURM_JOB_PARTITION" == "icelake" ]; then
  module load rhel8/default-icl
fi
module load FastQC/0.11.9

CMD="fastqc --quiet --threads 12 --noextract *.fq.gz"

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
