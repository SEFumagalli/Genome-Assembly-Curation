#!/bin/bash -l

#SBATCH --job-name=chromosome_map
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=short
#SBATCH --account=cattle_genome_assemblies
#SBATCH --chdir=/90daydata/cattle_genome_assemblies/Gyr/assembly
#SBATCH --output=chromosome_map__%j.std
#SBATCH --error=chromosome_map__%j.err

date

export MAMBA_ROOT_PREFIX=/project/cattle_genome_assemblies/packages/micromamba

eval "$(/project/cattle_genome_assemblies/packages/micromamba/bin/micromamba shell hook -s posix)"

micromamba activate pyfigures

echo "running chromosome map"
#python3 create_chromosome_map.py --chr_ids /90daydata/cattle_genome_assemblies/Gyr/assembly/ARS-UCD2.0_chr.fasta.idx
python3 create_chromosome_map.py --chr_ids /90daydata/cattle_genome_assemblies/Gyr/assembly/ARS-UCD2.0_chr.fasta --chr_num 31
	

date

