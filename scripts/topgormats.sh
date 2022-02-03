#!/usr/bin/env bash

line=`sed "${1}q;d" topgormats.txt`
dir=`echo "$line" | awk '{ print $1 }'`
event=`echo "$line" | awk '{ print $2 }'`

run_topgo.pl \
    --dir $dir/$event.topgo \
    --input_file $dir/$event.all.tsv \
    --genes_of_interest_file $dir/$event.sig.tsv \
    --gene_field 1 \
    --p_value_field 3 \
    --name_field 9 \
    --description_field 10 \
    --go_terms_file danio_rerio_e105_go.txt \
    --header 1
