#!/bin/bash

# Define variables   
THREADS=18                          # Number of threads to use

# Create output directory if it doesn't exist
mkdir -p ${OUTPUT_DIR}

# Get a list of _1.fq.gz files
FILE_LIST=(*_1.fq.gz)
INDEX=0
NUM_FILES=${#FILE_LIST[@]}

# While loop to process each file pair
while [ $INDEX -lt $NUM_FILES ]; do
  R1=${FILE_LIST[$INDEX]}
  BASE=$(basename ${R1} _1.fq.gz)
  R2="${BASE}_2.fq.gz"
  
  if [ -f "${R2}" ]; then
    # Define the output prefix for this pair
    OUTPUT_PREFIX="${BASE}."

    # Print debug information
    echo "Processing ${R1} and ${R2}"

    # Run STAR
    STAR --runThreadN ${THREADS} \
         --genomeDir star_ref_mm10_Refseq \
         --readFilesIn ${R1} ${R2} \
         --readFilesCommand zcat \
         --outFileNamePrefix ${OUTPUT_PREFIX} \
         --outSAMtype BAM Unsorted \
         --sjdbGTFfile mm10.ncbiRefSeq.gtf \
         --outFilterMultimapNmax 20 \
         --alignSJoverhangMin 8 \
         --alignSJDBoverhangMin 1 \
         --outFilterMismatchNmax 999 \
         --outFilterMismatchNoverLmax 0.04 \
         --alignIntronMin 20 \
         --alignIntronMax 1000000 \
         --alignMatesGapMax 1000000
  else
    echo "Error: Corresponding file for ${R1} not found."
  fi

  # Increment the index
  INDEX=$((INDEX + 1))
done
