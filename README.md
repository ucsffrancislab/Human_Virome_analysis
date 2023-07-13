# Human_Virome_analysis
* Kumata, Ito and Sato in prep
* main script : code.sh
* virus_genome_for_first_blast.fas : fasta file of masked viral genomes
* virus_genome_for_second_blast.fas : fasta file of clustered resemble masked viral genomes
* Detailed information on this pipeline in our published manuscript.
# 




```
makeblastdb -input_type fasta -dbtype nucl -parse_seqids \
	-in virus_genome_for_first_blast.fas \
	-out virus_genome_for_first_blast \
	-title virus_genome_for_first_blast 
```

```
makeblastdb -input_type fasta -dbtype nucl -parse_seqids \
	-in virus_genome_for_second_blast.fas \
	-out virus_genome_for_second_blast \
	-title virus_genome_for_second_blast 
```

