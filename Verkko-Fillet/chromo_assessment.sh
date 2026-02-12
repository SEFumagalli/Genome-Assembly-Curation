#!/bin/bash -l

#SBATCH --job-name=chromo_assessment
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3000
#SBATCH --partition=short
#SBATCH --qos=agil
#SBATCH --time=1-00:00:00
#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/
#SBATCH --output=chromo_assessment__%j.std
#SBATCH --error=chromo_assessment__%j.err

date

## ----------------------------------------------------------------------------------------------
## Input: datatype -> "trio_hic", "trio", or "hic"
## 	  chrnum   -> default is 31
##	  assembly -> path to verkko assembly directory
##        main_dir -> path to main assembly direcory
##
## This script runs Sergey's post verkko scripts that Temitayo Olagunju helped format
## to Ceres. 
##  
## Output: utig4_2_utig1
##	   assembly.gaps.bed
## 	   assemlby.t2t_ctgs
## 	   assembly.t2t_scfs
## 	   assembly.telomere.bed
##	   translation_hap1
##	   translation_hap2
##	   chr_completeness_max_hap1
##	   chr_completeness_max_hap2
##	   
## This script double checks mashmap.out for chromosome names, then combines files 
## for easy referencing.
##
## Output: translation_merged.tsv
##
## This script creates a heatmap that depicts information in the combined table.
## 
## Output: contigPlot.png
## ----------------------------------------------------------------------------------------------


datatype="trio_hic"
chrnum=31
assembly="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec"
main_dir="/90daydata/ruminant_t2t/Gyr/assembly"


echo "Build translation between hifi and final nodes"
python3 /project/cattle_genome_assemblies/packages/verkkoPostASMScripts/utig4_to_utig1.py . > utig4_2_utig1

echo "Get t2t stats"
bash /project/cattle_genome_assemblies/packages/verkkoPostASMScripts/getT2T.sh assembly.fasta

echo "Align to reference and generate names for chromosomes to plot"
bash /project/cattle_genome_assemblies/packages/verkkoPostASMScripts/getChrNames.sh /project/ruminant_t2t/existing_NCBI_references/Gyr/ARS-UCD2.0_chr.fasta

echo "Remove cattle rDNA"
bash /project/cattle_genome_assemblies/packages/verkkoPostASMScripts/removeRDNA.sh $main_dir/Cattle_rDNA.fasta



echo "Double checking translation files"
micromamba activate pyfigures

cp $assembly/translation_hap1 $assembly/translation_hap1_original
cp $assembly/translation_hap2 $assembly/translation_hap2_original

sort -k2,2 $assembly/translation_hap1 > $assembly/translation_hap1_sorted
sort -k2,2 $assembly/translation_hap2 > $assembly/translation_hap2_sorted

if [ "trio_hic" = $datatype ]; then
    echo "Using trio and hic data"
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "haplotype1" > $assembly/mashmap_hap1.out
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "haplotype2" > $assembly/mashmap_hap2.out

    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "dam" > $assembly/mashmap_dam.out
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "sire" > $assembly/mashmap_sire.out

    python3 $main_dir/chromo_assessment.py --mashmap $assembly/mashmap_dam.out $assembly/mashmap_sire.out $assembly/mashmap_hap1.out $assembly/mashmap_hap2.out --translation $assembly/translation_hap1_sorted $assembly/translation_hap2_sorted --num_chromosomes $chrnum

    rm $assembly/mashmap_hap1.out
    rm $assembly/mashmap_hap2.out
    rm $assembly/mashmap_dam.out
    rm $assembly/mashmap_sire.out
fi
if [ "trio" = $datatype ]; then
    echo "Using trio data only"
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "dam" > $assembly/mashmap_dam.out
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "sire" > $assembly/mashmap_sire.out

    python3 $main_dir/chromo_assessment.py --mashmap $assembly/mashmap_dam.out $assembly/mashmap_sire.out --translation $assembly/translation_hap1_sorted $assembly/translation_hap2_sorted --num_chromosomes $chrnum

    rm $assembly/mashmap_dam.out
    rm $assembly/mashmap_sire.out

fi

if [ "hic" = $datatype ]; then
    echo "Using hic data only"
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "haplotype1" > $assembly/mashmap_hap1.out
    sort -k11,11nr $assembly/mashmap.out | head -n 1500 | sort -k6,6 -k8,8n | grep "haplotype2" > $assembly/mashmap_hap2.out

    python3 $main_dir/chromo_assessment.py --mashmap $assembly/mashmap_hap1.out $assembly/mashmap_hap2.out --translation $assembly/translation_hap1_sorted $assembly/translation_hap2_sorted --num_chromosomes $chrnum

    rm $assembly/mashmap_hap1.out
    rm $assembly/mashmap_hap2.out

fi

rm $assembly/translation_hap1_sorted
rm $assembly/translation_hap2_sorted
mv $assembly/translation_hap1.csv translation_hap1
mv $assembly/translation_hap2.csv translation_hap2



echo "merging translation hap1/2 tables with t2t ctgs, scfs, gaps and telomeres"
python3 $main_dir/translation_merge_table_plot.py --verkkoDir $assembly --phase_datatype $datatype


date
