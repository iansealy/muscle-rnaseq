#!/usr/bin/env bash

line=`sed "${1}q;d" deseq2.txt`
eval $line
