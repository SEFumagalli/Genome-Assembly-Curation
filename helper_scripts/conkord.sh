# created by Sarah E. Fumagalli

## This script runs Conkord for each rDNA consensus and organizes the output files

#!/bin/bash -l

#SBATCH --job-name=conkord-chr25_hap2
#SBATCH --cpus-per-task=96
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3968
#SBATCH --partition=ceres
#SBATCH --qos=agil
#SBATCH --account=cattle_genome_assemblies
#SBATCH --time=4-00:00:00
#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly/conkord/CONKORD
#SBATCH --output=conkord-chr25_hap2__%j.std
#SBATCH --error=conkord-chr25_hap2__%j.err


date

micromamba activate verkko-v2.2.1
module load bedtools
module load jellyfish2 # I used jellyfish 2.2.9, old version will throw errors!
module load samtools
#pip install numpy matplotlib seaborn # needed for Call_Copy_Number_GC_Normalization_Version8.py

## -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
## Parameters:
## --no_uniq Used the default ("on"), as this run was for rDNA features
## -k 31 Used default k-mer size, in accordance with the literature as a reasonable length
## -f chr{8,10}.hap{1,2}.consensus.fa Ribotin consensus.fa output file; fasta of consensus morph for each tangle
## -bed assembly.haplotype{1,2}.chr{8,10}rDNA.bed BED file formatted as: Chr/Hapmer# | Start Coordinate rDNA region | End Coordinate rDNA region
## -r /project/ruminant_t2t/Pig/illumina_data/F1/ Directory containing illumina reads for the F1 individual
## -g assembly.haplotype{1,2}.fasta Verkko assembly for each individual haplotype (there will be multiple runs of CONKORD, one for each rDNA tangle on each haplotype)
## -gzip Illumina reads gzipped, not needed if not compressed
## -t 15 Number of threads used on USDA ceres
## -w_size 30500 Approximate length of pig rDNA morph (get from consensus.fa or reference.fa)
## --cluster # Indicate that script is being executed on USDA ceres
## ------------------------------------------------------------------------------------------------------------------------------------------------------------------------

prefix="chr25.hap2."

#echo 'Haplotype2-Chr11'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype2.chr11rDNA.bed -f ../chr11.hap2.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype2.fasta -w_size 35000 -t 15 --cluster --gzip

#echo 'Haplotype1-Chr11'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype1.chr11rDNA.bed -f ../chr11.hap1.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype1.fasta -w_size 35000 -t 15 --cluster --gzip

#echo 'Haplotype1-Chr3'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype1.chr3rDNA.bed -f ../chr3.hap1.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype1.fasta -w_size 35000 -t 15 --cluster --gzip

#echo 'Haplotype2-Chr3'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype2.chr3rDNA.bed -f ../chr3.hap2.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype2.fasta -w_size 35000 -t 15 --cluster --gzip

#echo 'Haplotype2-Chr2'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype2.chr2rDNA.bed -f ../chr2.hap2.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype2.fasta -w_size 15000 -t 15 --cluster --gzip

#echo 'Haplotype1-Chr25'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype1_2.chr25rDNA.bed -f ../chr25.hap1_2.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype1.fasta -w_size 35000 -t 15 --cluster --gzip

#echo 'Haplotype2-Chr25'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype1_2.chr25rDNA.bed -f ../chr25.hap1_2.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype2.fasta -w_size 10 -t 15 --cluster --gzip

#echo 'Haplotype1-Chr_'
#python3 conkord.py --no_uniq -k 31 -bed ../assembly.haplotype1.chr_rDNA.bed -f ../chr_.hap1.consensus.fa -r ../illumina/F1/ -g ../assembly.haplotype1.fasta -w_size 15000 -t 15 --cluster --gzip



#move png files to folder named figures
#mkdir figures 

file1="adjusted_feature_counts.png"
file2="raw_feature_counts.png"
file3="adjusted_matched_window_counts.png"

mv "$file1" "figures/${prefix}${file1}"
mv "$file2" "figures/${prefix}${file2}"
mv "$file3" "figures/${prefix}${file3}"


date
