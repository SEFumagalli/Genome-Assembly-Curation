#!/bin/bash -l

#SBATCH --job-name=join_gfastats
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=short
#SBATCH --qos=agil
#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly
#SBATCH --output=join_gfastats__%j.std
#SBATCH --error=join_gfastats__%j.err


## -----------------------------------------------------------------------
## This script collects each assembly's gfa haplotype stats and combines
## them in a single csv.
##
## Requirement: gfastats stat files created for each assembly
##
## Input for each assembly: haplotype1.fasta.stats
##                          haplotype2.fasta.stats
##
## Easily add or subtract the number of assemblies by adding or 
## removing the number of lists and filenames (sh file), and 
## arguments and file list (py file).
##
## Output: gfastats.csv
##         gfastats.png
## -----------------------------------------------------------------------


date


#run gfastats for each assembly
#/project/cattle_genome_assemblies/packages/gfastats/gfastats --out-coord g -f assembly.haplotype1.fasta > assembly.haplotype1.fasta.gaps &
#/project/cattle_genome_assemblies/packages/gfastats/gfastats --out-coord g -f assembly.haplotype2.fasta > assembly.haplotype2.fasta.gaps


micromamba activate pyfigures

python3 join_gfastats.py \
	--lista verkko2.2_hifi_hic/assembly.haplotype1.fasta.stats verkko2.2_hifi_hic/assembly.haplotype2.fasta.stats \
	--listb verkko2.2_hifi_porec/assembly.haplotype1.fasta.stats verkko2.2_hifi_porec/assembly.haplotype2.fasta.stats \
	--listc verkko2.2.1_hifi_trio/assembly.haplotype1.fasta.stats verkko2.2.1_hifi_trio/assembly.haplotype2.fasta.stats \
	--listd verkko2.2_hifi-duplex_hic/assembly.haplotype1.fasta.stats verkko2.2_hifi-duplex_hic/assembly.haplotype2.fasta.stats \
	--liste verkko2.2_hifi-duplex_porec/assembly.haplotype1.fasta.stats verkko2.2_hifi-duplex_porec/assembly.haplotype2.fasta.stats \
	--listf verkko2.2.1_hifi-duplex_trio/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-duplex_trio/assembly.haplotype2.fasta.stats \
 	--listg verkko2.2.1_hifi-duplex_tporec/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-duplex_tporec/assembly.haplotype2.fasta.stats \
	--listh verkko2.2_duplex_hic/assembly.haplotype1.fasta.stats verkko2.2_duplex_hic/assembly.haplotype2.fasta.stats \
	--listi verkko2.2.1_duplex_porec/assembly.haplotype1.fasta.stats verkko2.2.1_duplex_porec/assembly.haplotype2.fasta.stats \
	--listj verkko2.2.1_duplex_trio/assembly.haplotype1.fasta.stats verkko2.2.1_duplex_trio/assembly.haplotype2.fasta.stats \
	--listk verkko2.2.1_hifi-herro_hic/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-herro_hic/assembly.haplotype2.fasta.stats \
	--listl verkko2.2.1_hifi-herro_porec/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-herro_porec/assembly.haplotype2.fasta.stats \
	--listm verkko2.2.1_hifi-herro_trio/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-herro_trio/assembly.haplotype2.fasta.stats \
	--listn verkko2.2.1_herro_hic/assembly.haplotype1.fasta.stats verkko2.2.1_herro_hic/assembly.haplotype2.fasta.stats \
	--listo verkko2.2.1_herro_porec/assembly.haplotype1.fasta.stats verkko2.2.1_herro_porec/assembly.haplotype2.fasta.stats \
	--listp verkko2.2.1_herro_trio/assembly.haplotype1.fasta.stats verkko2.2.1_herro_trio/assembly.haplotype2.fasta.stats \
	--listq verkko2.2.1_hifi-q36_hic/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-q36_hic/assembly.haplotype2.fasta.stats \
	--listr verkko2.2.1_hifi-q36_porec/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-q36_porec/assembly.haplotype2.fasta.stats \
	--lists verkko2.2.1_hifi-q36_trio/assembly.haplotype1.fasta.stats verkko2.2.1_hifi-q36_trio/assembly.haplotype2.fasta.stats \
	--filenames 'HiFi Omni-C Hap1' 'HiFi Omni-C Hap2' 'HiFi Pore-C Hap1' 'HiFi Pore-C Hap2' 'HiFi Trio Hap1' 'HiFi Trio Hap2' 'HiFi-Duplex Omni-C Hap1' 'HiFi-Duplex Omni-C Hap2' 'HiFi-Duplex Pore-C Hap1' 'HiFi-Duplex Pore-C Hap2' 'HiFi-Duplex Trio Hap1' 'HiFi-Duplex Trio Hap2' 'HiFi-Duplex TPore-C Hap1' 'HiFi-Duplex TPore-C Hap2' 'Duplex Omni-C Hap1' 'Duplex Omni-C Hap2' 'Duplex Pore-C Hap1' 'Duplex Pore-C Hap2' 'Duplex Trio Hap1' 'Duplex Trio Hap2' 'HiFi-Herro Omni-C Hap1' 'HiFi-Herro Omni-C Hap2' 'HiFi-Herro Pore-C Hap1' 'HiFi-Herro Pore-C Hap2' 'HiFi-Herro Trio Hap1' 'HiFi-Herro Trio Hap2' 'Herro Omni-C Hap1' 'Herro Omni-C Hap2' 'Herro Pore-C Hap1' 'Herro Pore-C Hap2' 'Herro Trio Hap1' 'Herro Trio Hap2' 'HiFi-q36 Omni-C Hap1' 'HiFi-q36 Omni-C Hap2' 'HiFi-q36 Pore-C Hap1' 'HiFi-q36 Pore-C Hap2' 'HiFi-q36 Trio Hap1' 'HiFi-q36 Trio Hap2'\
	--csvname Gyr_assembly_haplotype_gfastats \
	--graphname Gyr_haplotype_N50

date
