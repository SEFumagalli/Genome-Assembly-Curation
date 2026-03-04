#created by Sarah E. Fumagalli

## This script reformats the gap_fixes file so that its ready to be processed by the perl script addPatch.pl
## perl script can be found on LeeAckersonIV github - https://github.com/LeeAckersonIV/genome-asm/blob/main/helper-scripts/addPatch.pl
## currently the perl script cannot handle utig1 translations
## see Example Files for gap_fixes.txt (manual curated file) and verkko_initial_gaps.csv (created by running verkko-fillet with the gaps flag)


#!/bin/bash -l

#SBATCH --job-name=reformat_gapfixes_for_perl
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3500
#SBATCH --partition=medium
#SBATCH --qos=agil
#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/verkko2.2.1_hifi-duplex_tporec_patch/gaps
#SBATCH --output=reformat_gapfixes_for_perl__%j.std
#SBATCH --error=reformat_gapfixes_for_perl__%j.err



## ----------------------------------------------------------------------------------------------
## This script finds the corresponding hapmer for each gap and converts +/- into >/< 
##
## Inputs: gap_fixes.txt - manually created
## 	   verkko_initial_gaps.csv - found in verkko-fillet/graphAlignment folder
##
## Output: converted_gap_fixes.tsv
## ----------------------------------------------------------------------------------------------



date

python3 /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/reformat_gapfixes_for_perl.py --gap_fixes gap_fixes.txt --initial_gaps verkko_initial_gaps.csv

date
