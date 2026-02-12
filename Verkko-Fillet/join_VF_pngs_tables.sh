#!/bin/bash -l

#SBATCH --job-name=join_VF_pngs_tables
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=ceres
#SBATCH --qos=agil
#SBATCH --account=cattle_genome_assemblies
#SBATCH --chdir=/90daydata/ruminant_t2t/Chamois/assembly
#SBATCH --output=join_VF_pngs_tables__%j.std
#SBATCH --error=join_VF_pngs_tables__%j.err

date

micromamba activate pyfigures

python3 /project/cattle_genome_assemblies/config_files_scripts/Sarah_scripts/join_VF_pngs_tables.py \
        --assemblies verkko2.2.1_hifi-ontEC-UA12_omniC_verkko_fillet verkko2.2.1_hifi-ontEC-UA5_omniC_verkko_fillet verkko2.2.1_hifi_omniC_verkko_fillet verkko2.2.1_hifi_omniC-missing2ONT_verkko_fillet verkko2.2.1_ontEC_omniC_verkko_fillet \
        --main_dir /90daydata/ruminant_t2t/Chamois/assembly/

date
