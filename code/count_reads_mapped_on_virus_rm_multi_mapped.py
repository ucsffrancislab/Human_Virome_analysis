#!/usr/bin/env python

import sys,re
argvs = sys.argv

run_Id = re.sub(r'.+\/(SRR[0-9]+)_.+',r'\1',argvs[1])


f1 = open(argvs[1])
f2 = open(argvs[2])
max_Eval = float(argvs[3])

score_d1 = {}
score_d2 = {}

score_d_l = [score_d1, score_d2]
f_l = [f1,f2]

for i in range(2):
  score_d = score_d_l[i]
  f = f_l[i]
  #f.next()
  for line in f:
    line = line.strip().split()
    read,target = line[:2]
    read = re.sub(r'(.+)\/[12]',r'\1',read)
    score = float(line[-1])
    Eval = float(line[-2])
    if Eval < max_Eval:
      if read not in score_d:
        score_d[read] = {}
      score_d[read][target] = score

read_s = set(score_d1.keys()) & set(score_d2.keys())

count_d = {}
for read in read_s:
  d1 = score_d1[read]
  d2 = score_d2[read]
  target_s = set(d1.keys()) & set(d2.keys())
  if len(target_s) > 0:
    max_score_d = {}
    for target in target_s:
      score1 = d1[target]
      score2 = d2[target]
      max_score_d[target] = max(score1,score2)
    target_max_score_l = [kv[0] for kv in max_score_d.items() if kv[1] == max(max_score_d.values())]

    if len(target_max_score_l) == 1:
      target_max_score = target_max_score_l[0]
      if target_max_score not in count_d:
        count_d[target_max_score] = 0
      count_d[target_max_score] += 1


print "target\t" + run_Id
for target in count_d:
  count = count_d[target]
  out_l = [target,count]
  print "\t".join([str(c) for c in out_l])
