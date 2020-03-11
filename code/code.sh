# Human Virome analysis pipeline #
## Kumata, Ito and Sato in prep ##
#
# input : RNA-seq data
# output : viral read count

##requirements##
# Require the following programs
#   trimmomatic
#   STAR
#   featureCount
#   samtools
#   picard
#   python2
#   blastn
# Requiew the following genome
#   Human genome
#   prokaryota genome

# set directory #
path_to_input = ""
path_to_STAR = ""
path_to_unmapped = ""
path_to_database = ""
path_to_viral_hit_fasta = ""
path_to_res_first_blast = ""
path_to_res_first_blast = ""
path_to_count = ""
# set threshold
threshold = 1.0e-10

# 1. trimming #
java -Xms4g -jar trimmomatic \
    PE \
    -phred33 \
    ${path_to_input}/input_1.fastq \
    ${path_to_input}/input_2.fastq \
    ${path_to_input}/input_1.fastq.trimmed \
    ${path_to_input}/input_2.fastq.trimmed \
    MINLEN:50 \
    SLIDINGWINDOW:4:20


# 2. STAR mapping to human genome #
STAR \
     --genomeDir path/to/human_genome \
     --readFilesIn ${path_to_input}/input_1.fastq.trimmed \
                   ${path_to_input}/input_2.fastq.trimmed \
     --outFilterMultimapScoreRange 1 \
     --outFilterMultimapNmax 10 \
     --outFilterMismatchNmax 5 \
     --alignIntronMax 500000 \
     --alignMatesGapMax 1000000 \
     --sjdbScore 2 \
     --alignSJDBoverhangMin 1 \
     --genomeLoad NoSharedMemory \
     --limitBAMsortRAM 0 \
     --outFilterMatchNminOverLread 0.33 \
     --outFilterScoreMinOverLread 0.33 \
     --sjdbOverhang 100 \
     --outSAMstrandField intronMotif \
     --outSAMattributes NH HI NM MD AS XS \
     --outSAMunmapped Within \
     --outSAMtype BAM Unsorted \
     --outSAMheaderHD @HD VN:1.4

# 3. extract unmapped reads
samtools view -f 12 -F 256 ${path_to_STAR}/STAR_aligned.out.bam | \
    java -Xms5g -Xmx5g -jar picard SamToFastq \
    I=/dev/stdin \
    FASTQ=${path_to_unmapped}/unmapped_1.fastq \
    SECOND_END_FASTQ=${path_to_unmapped}/unmapped_2.fastq

## convert fastq to fasta ##
python2 fastq2fasta.py ${path_to_unmapped}/unmapped_1.fastq >
 ${path_to_unmapped}/unmapped_1.fas
python2 fastq2fasta.py ${path_to_unmapped}/unmapped_2.fastq >
 ${path_to_unmapped}/unmapped_2.fas

# 4. First blast search #
blastn -db ${path_to_database}/virus_genome_for_first_blast.db \ # prepare blastn database from virus_genome_for_first_blast.fa
               -query ${path_to_unmapped}/unmapped_1.fas \
               -out ${path_to_res_first_blast}/res_first_blast_1.txt \
               -word_size 11 -outfmt 6 -num_threads 8

blastn -db ${path_to_database}/virus_genome_for_first_blast.db \
               -query ${path_to_unmapped}/unmapped_2.fas \
               -out ${path_to_res_first_blast}/res_first_blast_2.txt \
               -word_size 11 -outfmt 6 -num_threads 8

# 5. Extract viral hit reads #
python2 extract_vread.py \
    ${path_to_res_first_blast}/res_first_blast_1.txt \
    ${path_to_unmapped}/unmapped_1.fas > ${path_to_viral_hit_fasta}/viral_hit_fasta_1.fas

python2 extract_vread.py \
    ${path_to_res_first_blast}/res_first_blast_2.txt \
    ${path_to_unmapped}/unmapped_2.fas > ${path_to_viral_hit_fasta}/viral_hit_fasta_2.fas

# 6. Second blast search #
blastn -db ${path_to_database}/human_and_prokaryota_and_virus_genome.db \ # prepare blastn database from three fasta file: human genome, prokaryota genome, virus_genome_for_first_blast.fa
              -query ${path_to_viral_hit_fasta}/viral_hit_fasta_1.fas \
              -out ${path_to_res_second_blast}/res_second_blast_1.txt \
              -word_size 11 -outfmt 6 -num_threads 24 -evalue 0.01
blastn -db ${path_to_database}/human_and_prokaryota_and_virus_genome.db \ 
              -query ${path_to_viral_hit_fasta}/viral_hit_fasta_2.fas \
              -out ${path_to_res_second_blast}/res_second_blast_2.txt \
              -word_size 11 -outfmt 6 -num_threads 24 -evalue 0.01

# 7. count viral hit reads #
python2 script/count_reads_mapped_on_virus_rm_multi_mapped.py \
    ${path_to_res_second_blast}/res_second_blast_1.txt \
    ${path_to_res_second_blast}/res_second_blast_2.txt \
    ${threshold} \
    ${run_id} > ${path_to_count}/count.txt

