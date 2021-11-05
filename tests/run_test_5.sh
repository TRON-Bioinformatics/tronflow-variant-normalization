#!/bin/bash


source bin/assert.sh
output_folder=output/test5
nextflow main.nf -profile test,conda --output $output_folder --input_vcfs false --input_vcf test_data/test_single_sample.vcf
test -s $output_folder/test_single_sample/test_single_sample.normalized.vcf || { echo "Missing test 4 output file!"; exit 1; }
assert `wc -l $output_folder/test_single_sample/test_single_sample.normalized.vcf` 54