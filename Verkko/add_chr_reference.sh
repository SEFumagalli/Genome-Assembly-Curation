#!/bin/bash -l

#SBATCH --job-name=add_chr_reference
#SBATCH --cpus-per-task=2
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=ceres
#SBATCH --qos=agil
#SBATCH --account=cattle_genome_assemblies
#SBATCH --time=1-00:00:00
#SBATCH --chdir=/project/ruminant_t2t/existing_NCBI_references/Siberian_Musk_Deer
#SBATCH --output=add_chr_reference__%j.std
#SBATCH --error=add_chr_reference__%j.err

date

## ----------------------------------------------------------------------------------------------------------------
## Needed for script:
## 
## 1) Create chromosome map file
## 	- create a file called chromosome.map located in your main_directory - not assembly directory
##	- this file will have no header, no index, just two columns: 1) RefSeq identifier and 2) chromosome number
##	- make note of the formatting in the second column - do not forget to use '_'
##	- example:
##		NC_037328.1     chr_1
##		NC_037329.1     chr_2
##		NC_037330.1     chr_3
##		NC_037331.1     chr_4
##		NC_037332.1     chr_5
##		NC_037333.1     chr_6
##		NC_037334.1     chr_7
##		NC_037335.1     chr_8
##		NC_037336.1     chr_9
##		NC_037337.1     chr_10
##		NC_037338.1     chr_11
##		NC_037339.1     chr_12
##		NC_037340.1     chr_13
##		NC_037341.1     chr_14
##		NC_037342.1     chr_15
##		NC_037343.1     chr_16
##		NC_037344.1     chr_17
##		NC_037345.1     chr_18
##		NC_037346.1     chr_19
##		NC_037347.1     chr_20
##		NC_037348.1     chr_21
##		NC_037349.1     chr_22
##		NC_037350.1     chr_23
##		NC_037351.1     chr_24
##		NC_037352.1     chr_25
##		NC_037353.1     chr_26
##		NC_037354.1     chr_27
##		NC_037355.1     chr_28
##		NC_037356.1     chr_29
##		NC_037357.1     chr_X
##		NC_082638.1     chr_Y 
##
##
## **Alternate method: This script can also be used if your reference.fasta was produced from running hifiasm or 
## for whatever reason have an extra column of information to map**
##
## 1) Create extended chromosome map file
##      - create a file similar to chromosome.map located in your main_directory - not assembly directory
##	- !! name this file something other than chromosome.map - it will be rewritten
##      - this file will have no header, no index, just three columns: 1) ID, 2) RefSeq identifier, & 3) chromosome number
##      - make note of the formatting in the second column - do not forget to use '_'
##      - example:
##        	h1tg000033l     NC_000001.1     chr_1
##		h2tg000020l_h2tg000029l NC_000002.1     chr_2
##		h1tg000005l     NC_000003.1     chr_3
##		h1tg000017l     NC_000004.1     chr_4
##		h1tg000020l     NC_000005.1     chr_5
##		h1tg000014l     NC_000006.1     chr_6
##		h1tg000003l     NC_000007.1     chr_7
##		h1tg000019l     NC_000008.1     chr_8
##		h1tg000004l     NC_000009.1     chr_9
##		h1tg000032l     NC_000010.1     chr_10
##		h1tg000030l     NC_000011.1     chr_11
##		h1tg000001l     NC_000012.1     chr_12
##		h1tg000016l     NC_000013.1     chr_13
##		h1tg000008l     NC_000014.1     chr_14
##		h1tg000002l     NC_000015.1     chr_15
##		h1tg000018l     NC_000016.1     chr_16
##		h2tg000021l     NC_000017.1     chr_17
##		h1tg000036l     NC_000018.1     chr_18
##		h1tg000026l     NC_000019.1     chr_19
##		h2tg000012l_h2tg000034l NC_000020.1     chr_20
##		h1tg000021l     NC_000021.1     chr_21
##		h1tg000013l     NC_000022.1     chr_22
##		h1tg000012l     NC_000023.1     chr_23
##		h1tg000009l     NC_000024.1     chr_24
##		h2tg000007l_h2tg000031l NC_000025.1     chr_25
##		h1tg000025l     NC_000026.1     chr_26
##		h1tg000022l_h1tg000035l NC_000027.1     chr_27
##		h2tg000025l     NC_000028.1     chr_28
##		h1tg000011l     NC_000029.1     chr_X
##		h1tg000024l     NC_000030.1     chr_Y
##
## 2) Reference downloaded to main_directory
##
## Output: Updated reference file using chromosome.map names instead of detailed sequence IDs
##	   If alternate method is used, a chromosome.map file is also created to run with verkko-fillet
##
## ---------------------------------------------------------------------------------------------------------------	

#chromosome.map or extendend chromosome map file
map_file="/project/ruminant_t2t/existing_NCBI_references/Siberian_Musk_Deer/renaming.chromosomes"
reference="/project/ruminant_t2t/existing_NCBI_references/Siberian_Musk_Deer/Musk_Deer_hifiasmONT_primary_T2T_hap1base.fasta"
#add .chr to reference name to run indexing
#add_chr_reference.py will add .chr to the file name automatically
#example: original file - Pronghorn_hifiasmONT_primaryNC.fasta
        # updated file - Pronghorn_hifiasmONT_primaryNC.chr.fasta
new_reference="/project/ruminant_t2t/existing_NCBI_references/Siberian_Musk_Deer/Musk_Deer_hifiasmONT_primary_T2T_hap1base.chr.fasta"


micromamba activate jcvi
python3 add_chr_reference.py --chromosome_map $map_file --reference $reference


module load seqkit
seqkit faidx $new_reference

date
