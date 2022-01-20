#!/usr/bin/env bash

dir=`sed "${1}q;d" topgo.txt`

run_topgo.pl \
    --dir $dir/topgo \
    --input_file $dir/all.tsv \
    --genes_of_interest_file $dir/sig.tsv \
    --gene_field 1 \
    --p_value_field 3 \
    --fold_change_field 4 \
    --name_field 10 \
    --description_field 11 \
    --go_terms_file danio_rerio_e105_go.txt \
    --header 1
