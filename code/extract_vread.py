#!/usr/bin/env python2
#This script extract reads assigned to features from blast_search
# Input: blast_result(output format 6)
# Output: query fasta file for previous blast
#
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

#	This is clearly reading a FASTA (2 lines) file
out = []
fst = open(fasta, "r")
fastl = []
for line in fst:
	line = line.strip()
	fastl.append(line)

#	This is clearly expecting to have read a FASTQ (4 lines) file
#for i in range(0,len(fastl),4): # clearly fastq
#	read = fastl[i]
#	seq = fastl[i + 1]
#	plus = fastl[i + 2] # clearly fastq
#	qual = fastl[i + 3] # clearly fastq

for i in range(0,len(fastl),2):
	read = fastl[i][1:] # remove leading ">" here
	seq = fastl[i + 1]
	if read in read_set:
		read = '>' + read
		l = [read,seq]
		print("\n".join(l))



