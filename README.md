# Human_Virome_analysis
* Kumata, Ito and Sato in prep
* main script : code.sh
* virus_genome_for_first_blast.fas : fasta file of masked viral genomes
* virus_genome_for_second_blast.fas : fasta file of clustered resemble masked viral genomes
* Detailed information on this pipeline in our published manuscript.
# 






##	Jake


###	From "A tissue level atlas of the healthy human virome"

https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-020-00785-5

#### Additional file 1: Table S1

Information on the RNA-Seq dataset used in this study.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM1_ESM.xlsx

#### Additional file 2: Table S2

List of the 39 viral species detected in this study.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM2_ESM.xlsx

#### Additional file 3: Table S3

Read count of the respective 39 viral species detected in this study.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM3_ESM.xlsx

#### Additional file 4: Figure S1

Read coverage on EBV, HHV-6 and HHV-7 genomes.

#### Additional file 5: Table S4
List of the genomic positions of the masked regions in each viral genome.

#### Additional file 6: Table S5

Information on the GTEx samples.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM6_ESM.xlsx

#### Additional file 7: Figure S2

Comparison of our analytical pipeline with the other pipelines.

#### Additional file 8: Figure S3

Deconvolution analysis in the blood of EBV-positive and -negative subjects.

#### Additional file 9: Figure S4

Deconvolution analysis in the spleen of EBV-positive and -negative subjects.

#### Additional file 10: Figure S5

Read mapping to Lassa virus segment L and Pepper chlorotic spot virus segment L.

#### Additional file 11: Table S6

Information on the viral genome sequences used in this study.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM11_ESM.xlsx

#### Additional file 12: Table S7

Information on the prokaryotic genome sequences used in this study.

https://static-content.springer.com/esm/art%3A10.1186%2Fs12915-020-00785-5/MediaObjects/12915_2020_785_MOESM12_ESM.xlsx





I don't see a direct link of viral counts to tissue types but I presume that this could be determined as each sample is from a specific tissue.

I have a file /francislab/data1/raw/20201006-GTEx/SraRunTable.txt that has 24455 samples


```
makeblastdb -input_type fasta -dbtype nucl -parse_seqids \
	-in virus_genome_for_first_blast.fas \
	-out virus_genome_for_first_blast \
	-title virus_genome_for_first_blast 
```

The sequences in virus_genome_for_second_blast.fas seem to be the same
as in virus_genome_for_first_blast.fas, but name changes and a few missing.

```
grep -c "^>" virus_genome_for_*fas
virus_genome_for_first_blast.fas:5139
virus_genome_for_second_blast.fas:5016
```

```
grep -m 5 -A1 --no-group-separator "^>" virus_genome_for_*fas | cut -c1-80
virus_genome_for_first_blast.fas:>NC_033697.1
virus_genome_for_first_blast.fas-ATGGTTAATCCAAAGGGCGTCAATGTAGTGGCTGGCCGCACTAAACG
virus_genome_for_first_blast.fas:>NC_008892.1
virus_genome_for_first_blast.fas-GCAGTTCCGTATCTCTTAATCATTAACGTTTATTTTTTAAAAGTCAA
virus_genome_for_first_blast.fas:>NC_022631.1
virus_genome_for_first_blast.fas-ACACAAAGACGCCAGCTATCAAGATGATGTTCTCACATGTACTGATG
virus_genome_for_first_blast.fas:>NC_032147.1
virus_genome_for_first_blast.fas-TGAGTAAACGGATAACCAATCTTTTTAAGATGAATAATCTACGAGAA
virus_genome_for_first_blast.fas:>NC_003113.1
virus_genome_for_first_blast.fas-TTTTAAATATCGGGTACAGGGTTTTAACCCTGTACCCGGTATTCAGA
virus_genome_for_second_blast.fas:>ID_66 <unknown description>
virus_genome_for_second_blast.fas-ATGGTTAATCCAAAGGGCGTCAATGTAGTGGCTGGCCGCACTAAAC
virus_genome_for_second_blast.fas:>ID_1101 <unknown description>
virus_genome_for_second_blast.fas-GCAGTTCCGTATCTCTTAATCATTAACGTTTATTTTTTAAAAGTCA
virus_genome_for_second_blast.fas:>ID_1944 <unknown description>
virus_genome_for_second_blast.fas-ACACAAAGACGCCAGCTATCAAGATGATGTTCTCACATGTACTGAT
virus_genome_for_second_blast.fas:>ID_3040 <unknown description>
virus_genome_for_second_blast.fas-TGAGTAAACGGATAACCAATCTTTTTAAGATGAATAATCTACGAGA
virus_genome_for_second_blast.fas:>ID_369 <unknown description>
virus_genome_for_second_blast.fas-TTTTAAATATCGGGTACAGGGTTTTAACCCTGTACCCGGTATTCAG
```

The relationship is not 1:1

```
tail -n +3 ~/github/ucsffrancislab/Human_Virome_analysis/12915_2020_785_MOESM11_ESM.tsv | sort -k3 | head

NC_001655.1	"Hepatitis_GB_virus_B,_complete_genome"	ID_1		
NC_038426.1	"Hepacivirus_B_polypeptide_gene,_complete_cds"	ID_1		
NC_014927.1	"Cyclovirus_PKgoat21/PAK/2009,_complete_genome"	ID_10		
NC_038405.1	"Cyclovirus_PKbeef23/PAK/2009_isolate_PKbeef23,_complete_genome"	ID_10		
NC_001540.1	"Bovine_parvovirus,_complete_genome"	ID_100		
NC_038895.1	"Bovine_parvovirus-1_strain_Abinanti,_complete_genome"	ID_100		
NC_008187.1	"Aedes_taeniorhynchus_iridescent_virus,_complete_genome"	ID_1000		
NC_008184.1	"Tursiops_truncatus_papillomavirus_2,_complete_genome"	ID_1001		
```

I'm think that the `virus_genome_for_second_blast.fas` was just the viral part for the second blast.
Not sure why the change in read names.
If true, building the second blast database will require downloading about a TB 
of bacterial genomes from RefSeq. A HUGE database. Probably why the initial data was
filtered by aligning to a smaller viral reference first.




```
zcat /c4/home/gwendt/github/ucsffrancislab/Human_Virome_analysis/virus_genome_for_second_blast.fas.gz /francislab/data1/refs/sources/gencodegenes.org/release_43/GRCh38.primary_assembly.genome.fa.gz /francislab/data1/refs/refseq/archaea-20230714/archaea.*.genomic.fna.gz /francislab/data1/refs/refseq/bacteria-20210916/bacteria.*.genomic.fna.gz | makeblastdb -input_type fasta -dbtype nucl -parse_seqids -out ${PWD}/db_for_second_blast -title db_for_second_blast
```




