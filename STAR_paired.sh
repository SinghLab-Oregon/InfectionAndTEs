#!/bin/bash


RUN="YES"
BASE="AAA"
THR=1 ## threads


date
printf "STAR aligning############# \n"
STAR --version

### STAR Genome Index
GENDIR="AAA/STAR_dmel-all-chromosome-r6.41_Genome/"

FASTQS=$( find ${BASE} -maxdepth 1 -type f -name "*fastq.gz" -exec ls {} + )
SAMPVEC=$( ls $FASTQS | sed 's!.*/!!' | awk '{m=split($0,a,".f"); for(i=1;i<m;i++)printf a[i]}; {print ""}' | sort | uniq )
SAMPNUM=$( ls $FASTQS | sed 's!.*/!!' | awk '{m=split($0,a,".f"); for(i=1;i<m;i++)printf a[i]}; {print ""}' | sort | uniq | wc -l)

printf "SAMPLES DETECTED = ${SAMPNUM} \n"
printf "FASTQ'S DETECTED = $(ls $FASTQS | wc -l ) \n"
echo $SAMPVEC

mkdir -p ../Data

for SAMP in $( echo $SAMPVEC );
do  
    printf "\n"
    echo "SAMPLE# = $SAMP"
    echo $SAMP
    R1=$( ls $FASTQS | grep $SAMP | grep "_1" )
    R2=$( ls $FASTQS | grep $SAMP | grep "_2" )
    echo "READ1####"
    ls -lh $R1
    echo "READ2####"
    ls -lh $R2

if [ "$RUN" = "YES" ]
    then
    TR1="${BASE}/Trimmed/Read1_Trim_${SAMP}.fastq.gz"
    TR2="${BASE}/Trimmed/Read2_Trim_${SAMP}.fastq.gz"

    echo "TRIMMED ##########"
    ls -lh $TR1
    INBAM="../Data/${SAMP}Aligned.out.bam"

    if [ ! -f  $INBAM ]; ## if Bam does not exist
        then
        echo "STAR"
        STAR --runMode alignReads --genomeDir $GENDIR --readFilesIn $R1 $R2 \
        --runThreadN $THR \
        --readFilesCommand gunzip -c \
        --outSAMtype BAM Unsorted \
        --quantMode GeneCounts  \
        --outFilterMismatchNmax 999 \
        --outFilterMismatchNoverReadLmax 0.05 \
        --outFileNamePrefix ../Data/${SAMP} \
        --outFilterType BySJout \
        --peOverlapNbasesMin 10

    fi
fi
done
