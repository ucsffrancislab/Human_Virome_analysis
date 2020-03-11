#!/usr/bin/env python2
import sys

blast_res = sys.argv[1]
fasta = sys.argv[2]

max_Eval = 1.0E-10

blast_f = open(blast_res, "r")
read_list = []
for line in blast_f:
    line = line.strip().split()
    read = line[0]
    Eval = line[10]
    Eval = float(Eval)

    if Eval < max_Eval:
        read_list.append(read)

read_set = set(read_list)

out = []
fst = open(fasta, "r")
fastl = []
for line in fst:
    line = line.strip()
    fastl.append(line)


for i in range(0,len(fastl),4):
    read = fastl[i]
    seq = fastl[i + 1]
    plus = fastl[i + 2]
    qual = fastl[i + 3]
    if read in read_set:
        read = '>' + read
        l = [read,seq]
        print("\n".join(l))



