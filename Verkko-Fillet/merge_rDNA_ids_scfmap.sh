#!/bin/bash -l

#SBATCH --job-name=rDNA_id_scfmap_smash
#SBATCH --cpus-per-task=4
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=8000
#SBATCH --partition=ceres
#SBATCH --time=2-00:00:00
#SBATCH --qos=memlimit
#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly
#SBATCH --output=rDNA_id_scfmap_smash__%j.std
#SBATCH --error=rDNA_id_scfmap_smash__%j.err

date


## ----------------------------------------------------------------------------------------------
## This script creates a table containing the data from fasta.fai and assembly.scfmap.
## This script creates a file with an easily copied list of rDNA utig4s for Bandage.
## This script assumes translation_merged.tsv has been created via chromo_assesment.sh or 
## through verkko-fillet.
##
## Inputs: assembly.cattle_rDNA.fasta.fai
##         assembly.scfmap
##
## Output: rDNA_utigs_ids.tsv
##         rDNA_utig_bandage.txt
##	   file lengths printed in .std
## ----------------------------------------------------------------------------------------------

verkko_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec"

# If fasta.fai file needs to be created, run seqkit

#micromamba activate seqkit

#seqkit faidx $verkko_dir/assembly.cattle_rDNA.fasta

#micromamba deactivate


python3 merge_rDNA_ids_scfmap.py --ids $verkko_dir/assembly.cattle_rDNA.fasta.fai --scfmap $verkko_dir/assembly.scfmap --table_output $verkko_dir/rDNA_utigs_ids --utig_output $verkko_dir/rDNA_utig_bandage
