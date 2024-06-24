#!/bin/bash

RUN="YES"
BASE="AAA"
PROJECT="AAA"

date
printf "###TEtranscripts Transposable Element Analysis ### \n"
TEtranscripts --version

##GTF gene annotations file
GTF_ANNO="AAA/Drosophila_melanogaster.BDGP6.32.104.gtf"
###TE-GTF transposable elements annotations file
TE_ANNO="AAA/dm6_BDGP_rmsk_TE.gtf"

ALIGNED=$( find ${BASE} -maxdepth 1 -type f -name "*Aligned.out.bam" -exec ls {} + )
TREAT=$( ls $ALIGNED | grep "w_plus" )
CONTROL=$( ls $ALIGNED | grep "w-" )
printf "Total BAM Files DETECTED = $(ls $ALIGNED | wc -l ) \n"
echo $ALIGNED
printf "Treatment Samples DETECTED = $(ls $TREAT | wc -l ) \n"
ls -lh $TREAT
printf "Control Samples DETECTED = $(ls $CONTROL | wc -l ) \n"
echo $CONTROL


if [ "$RUN" = "YES" ]
    then
    echo "TEtranscripts"
    ## single-end
    TEtranscripts \
        --mode multi \
        --TE ${TE_ANNO} \
        --GTF ${GTF_ANNO} \
        --project ${PROJECT} \
        -t  $TREAT \
        -c  $CONTROL 2>log
fi