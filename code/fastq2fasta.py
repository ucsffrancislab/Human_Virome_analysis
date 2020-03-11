#!/usr/bin/env python
# This script transform fastq file to fasta format filtering short reads
# input : fastq file
# output : fasta file
import sys
argvs = sys.argv
min_seq_len = 40

fastq_f = open(argvs[1])
fastq_l = []
for line in fastq_f:
  line = line.strip()
  fastq_l.append(line)

len_fastq_l = len(fastq_l)
for i in range(0,len_fastq_l,4):
  name = fastq_l[i]
  seq = fastq_l[i+1]
  if len(seq) > min_seq_len:
    print '>' + name + '\n' + seq
