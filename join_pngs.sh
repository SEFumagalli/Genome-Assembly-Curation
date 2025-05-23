#!/bin/bash -l

#SBATCH --job-name=join_pngs
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=short
#SBATCH --qos=agil
#SBATCH --chdir=/90daydata/ruminant_t2t/Chinese_Muntjac/assembly
#SBATCH --output=join_pngs__%j.std
#SBATCH --error=join_pngs__%j.err


## ---------------------------------------------------------------------
## This file quickly joins several png file for easy comparison. 
## 
## Requirement: Must have previously ran Verkko-fillet or 
## 		chromo_assesement.sh. 
##
## Input: configPlot.png for each assembly
##
## Output: contigPlot_merged.png
## ---------------------------------------------------------------------


date

micromamba activate pyfigures

python3 /project/cattle_genome_assemblies/config_files_scripts/join_pngs.py \
	--png_files /90daydata/ruminant_t2t/Chinese_Muntjac/assembly/verkko_2.2.1_ontEC_hic_verkko_fillet/chromosome_assignment/contigPlot.png /90daydata/ruminant_t2t/Chinese_Muntjac/assembly/verkko_2.2.1_hifi_hic_verkko_fillet/chromosome_assignment/contigPlot.png /90daydata/ruminant_t2t/Chinese_Muntjac/assembly/verkko_2.2.1_hifi-ontEC_hic_verkko_fillet/chromosome_assignment/configPlot.png /90daydata/ruminant_t2t/Chinese_Muntjac/assembly/verkko_2.2.1_hifi-ontEC_hic-UA12_verkko_fillet/chromosome_assignment/contigPlot.png \
	--final_png /90daydata/ruminant_t2t/Chinese_Muntjac/assembly/contigPlot_merged.png



date
