#!/bin/bash


source bin/assert.sh
output_folder=output/test4
nextflow main.nf -profile test,conda --input_vcfs test_data/test_input_no_ad.txt --output $output_folder
test -s $output_folder/sample_no_ad/sample_no_ad.normalized.vcf || { echo "Missing test 4 output file!"; exit 1; }
assert `wc -l $output_folder/sample_no_ad/sample_no_ad.normalized.vcf` 53