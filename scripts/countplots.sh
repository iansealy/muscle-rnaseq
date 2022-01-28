#!/usr/bin/env bash

line=`sed "${1}q;d" countplots.txt`
eval $line
