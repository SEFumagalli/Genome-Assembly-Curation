#!/bin/bash -l

#SBATCH --job-name=assembly_stats
#SBATCH --cpus-per-task=96
#SBATCH --ntasks=1
#SBATCH --mem-per-cpu=3968
#SBATCH --partition=ceres
#SBATCH --qos=agil
#SBATCH --time=3-00:00:00
#SBATCH --account=cattle_genome_assemblies
#SBATCH --chdir=/90daydata/ruminant_t2t/Pronghorn/assembly/
#SBATCH --output=assembly_stats__%j.std
#SBATCH --error=assembly_stats__%j.err


## ------------------------------------------------------------------------------------
## For a given assembly, this script finds the telomere counts, gaps, aligns 
## each haplotype to the reference, and calculates gfa stats.
## 
## Requirement: gfastats files created for each assembly
##
## Final input for each assembly: haplotype1.fasta.stats
##                                haplotype2.fasta.stats
##
## Output per haplotype: assembly.fasta.telo.counts 
##			 assembly.fasta.gaps
##			 assembly.paf
##			 assembly_gfa.stats
##
## Output per assembly: assembly.homopolymer-compressed_gfa.stats
##			gfastats.tsv
## ------------------------------------------------------------------------------------


date

reference="/project/ruminant_t2t/existing_NCBI_references/Pronghorn/Pronghorn_hifiasmONT_primaryNC.chr.fasta"
assemblies=("verkko2.2.1_hifi-duplex_UA4_hic" "verkko2.2.1_hifi-duplex_UA8_hic" "verkko2.2.1_hifi-duplex_hic" "verkko2.2.1_hifi_hic" "verkko2.2.1_ontEC_hic")

#column names for tables
filenames=("HiFi-Duplex UA4 Hi-C Hap1" "HiFi-Duplex UA4 Hi-C Hap2" "HiFi-Duplex UA8 Hi-C Hap1" "HiFi-Duplex UA8 Hi-C Hap2" "HiFi-Duplex Hi-C Hap1" "HiFi-Duplex Hi-C Hap2" "HiFi Hi-C Hap1" "HiFi Hi-C Hap2" "ontEC Hi-C Hap1" "ontEC Hi-C Hap2")

#table file name
tsv_gfa="Pronghorn_hap_gfastats"



for assembly in "${assemblies[@]}"
do
        echo "$assembly"

	echo "telomere counts"
	micromamba activate seqtk
	seqtk telo $assembly/assembly.haplotype1.fasta > $assembly/assembly.haplotype1.fasta.telo 2> $assembly/assembly.haplotype1.fasta.telo.counts
	seqtk telo $assembly/assembly.haplotype2.fasta > $assembly/assembly.haplotype2.fasta.telo 2> $assembly/assembly.haplotype2.fasta.telo.counts
	micromamba deactivate

	echo "gfastats to find gaps"
	/project/cattle_genome_assemblies/packages/gfastats/gfastats --out-coord g -f $assembly/assembly.haplotype1.fasta > $assembly/assembly.haplotype1.fasta.gaps
	/project/cattle_genome_assemblies/packages/gfastats/gfastats --out-coord g -f $assembly/assembly.haplotype2.fasta > $assembly/assembly.haplotype2.fasta.gaps

	echo "minimap2 to align verkko assembly to reference"
	micromamba activate minimap2
	minimap2 -x asm5 -t 48 $reference $assembly/assembly.haplotype1.fasta > $assembly/assembly.haplotype1.paf 2> $assembly/assembly.haplotype1.paf.err
	minimap2 -x asm5 -t 48 $reference $assembly/assembly.haplotype2.fasta > $assembly/assembly.haplotype2.paf 2> $assembly/assembly.haplotype2.paf.err
	micromamba deactivate

	echo "gfastats for assembly stats"
	/project/cattle_genome_assemblies/packages/gfastats/gfastats $assembly/assembly.haplotype1.fasta > $assembly/assembly_hap1_gfa.stats
	/project/cattle_genome_assemblies/packages/gfastats/gfastats $assembly/assembly.haplotype2.fasta > $assembly/assembly_hap2_gfa.stats

	echo "gfastats for assembly graph"
	/project/cattle_genome_assemblies/packages/gfastats/gfastats --discover-paths -f $assembly/assembly.homopolymer-compressed.gfa > $assembly/assembly.homopolymer-compressed_gfa.stats

done


micromamba activate pyfigures

echo "join gfastats"
python3 /project/cattle_genome_assemblies/config_files_scripts/Sarah_scripts/join_gfastats.py \
        --assemblies "${assemblies[@]}" \
        --filenames "${filenames[@]}" \
        --tsv_gfa $tsv_gfa



date
