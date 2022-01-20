#!/usr/bin/env bash

line=`sed "${1}q;d" zfa.txt`
eval $line
