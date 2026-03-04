#created by Sarah E. Fumagalli

patch_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/assembly_patches"
verkko_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec"
verkko_fillet_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec_verkko_fillet"

## ------------------------------------------------------------------------------------------------------------------------------------------------
##
##
## Create loose telomere patches 
##
##
## ------------------------------------------------------------------------------------------------------------------------------------------------



# Find telomeres not assigned a chromosome

	This list can be found at the bottome of the translation_merged.tsv created by verkko-fillet

					    telomeres  gaps    utig4(Bandage)	
	dam_compressed.k31.hapmer-0000006      1.0     2.0     utig4-1532
	dam_compressed.k31.hapmer-0000013      1.0             utig4-1853
	dam_compressed.k31.hapmer-0000170      1.0             utig4-1864
	haplotype2-0000346                     1.0     1.0     utig4-2468
	sire_compressed.k31.hapmer-0000674     1.0     1.0     utig4-1772
	sire_compressed.k31.hapmer-0000689     1.0     1.0     utig4-2356
	sire_compressed.k31.hapmer-0001022     1.0             utig4-456


	Only two telomeres need a patch-like fix (see other telomere fixes in PP):
	    1. one was named a gap by verkko-fillet --> gapid_38
	    2. haplotype2-0000346



	cd verkko2.2.1_hifi-duplex_tporec/8-manualResolution/verkko2.2.1_hifi-duplex_tporec_patch/telomere_alignments/
	mkdir telo_1854
	mkdir telo_2468



# Identify flanking utigs

	telo_1854:
	grep utig4-1854 5-untip/unitig-unrolled-unitig-unrolled-popped-unitig-normal-connected-tip.gfa | awk '/^S/{print ">"$2;print $3}' > utig4-1854.fasta
	grep utig4-2375 5-untip/unitig-unrolled-unitig-unrolled-popped-unitig-normal-connected-tip.gfa | awk '/^S/{print ">"$2;print $3}' > utig4-2375.fasta

	telo_2468:
	grep utig4-1550 5-untip/unitig-unrolled-unitig-unrolled-popped-unitig-normal-connected-tip.gfa | awk '/^S/{print ">"$2;print $3}' > utig4-1550.fasta
	grep utig4-2468 5-untip/unitig-unrolled-unitig-unrolled-popped-unitig-normal-connected-tip.gfa | awk '/^S/{print ">"$2;print $3}' > utig4-2468.fasta
	grep -A1 haplotype2-0000346 assembly.fasta



# Compress file

	micromamba activate seqtk

	telo_2468:
	seqtk hpc hap2_346.fasta > hap2_346.fasta.hpc



# Align utigs

	micromamba activate minimap2

	telo_1854:
	minimap2 -x asm5 -t 48 utig4-2375.fasta utig4-1854.fasta > utig4-2375_utig4-1854.paf 2> utig4-2375_utig4-1854.err

	telo_2468:
	minimap2 -x asm5 -t 48 utig4-2468.fasta utig4-1550.fasta > utig4-2468_utig4-1550.paf 2> utig4-2468_utig4-1550.err
	minimap2 -x asm5 -t 48 hap2_346.fasta.hpc utig4-2468.fasta > utig4-2468_hap2_346.paf 2> utig4-2468_hap2_346.err



# Sort alignments and choose best

	telo_1854:
	sort -k 12nr utig4-2375_utig4-1854.paf > utig4-2375_utig4-1854_sorted.paf
		line 2 shows an alignment close to the end of both utigs

	telo_2468:
	utig4-2468_hap2_346.paf
		the majority of telomere utig4-2468 is captured at the end of haplotype2-0000346



# Cut line 2 segment from utig4-1854

	module load samtools

	telo_1854:
	samtools faidx utig4-1854.fasta utig4-1854:1889445-2768585 > utig4-1854_line2.fasta

	telo_2468:
	samtools faidx hap2_346.fasta.hpc haplotype2-0000346:2855680-7501567 > hap2_346_line1.fasta



# Realign to segment

	micromamba activate minimap2

	telo_1854:
	minimap2 -x asm5 -t 48 utig4-1854_line2.fasta utig4-1854.fasta > utig4-1854_utig4-1854_line2.paf 2> utig4-1854_utig4-1854_line2.err
	minimap2 -x asm5 -t 48 utig4-1854_line2.fasta utig4-2375.fasta > utig4-2375_utig4-1854_line2.paf 2> utig4-2375_utig4-1854_line2.err

	telo_2468:
	minimap2 -x asm5 -t 48 hap2_346_line1.fasta utig4-2468.fasta > utig4-2468_hap2_346_line1.paf 2> utig4-2468_hap2_346_line1.err
	minimap2 -x asm5 -t 48 hap2_346_line1.fasta hap2_346.fasta.hpc > hap2_346_hap2_346_line1.paf 2> hap2_346_hap2_346_line1.err



# Sort alignments and choose best

	telo_1854:
	sort -k12nr utig4-1854_utig4-1854_line2.paf > utig4-1854_utig4-1854_line2_sorted.paf
		line 1 is at the beginning of the segment and at the end of utig4-1854
	sort -k10nr utig4-2375_utig4-1854_line2.paf > utig4-2375_utig4-1854_line2_sorted.paf
		line 1 is near the end of the segment and utig4-2375, sharing many residues

	telo_2468:
	utig4-2468_hap2_346_line1.paf
		line 1 shows alignment at the beginning of utig4-2468 and the segment
	hap2_346_hap2_346_line1.paf 
		line 1 shows alignment at the end of hap2_346 and the segment



# Save alignments as patch

telo_1854:
sed -n '1p' utig4-1854_utig4-1854_line2_sorted.paf > utig4-1854_utig4-1854_line1_patch.paf
sed -n '1p' utig4-2375_utig4-1854_line2_sorted.paf > utig4-2375_utig4-1854_line1_patch.paf

telo_2468:
sed -n '1p' utig4-2468_hap2_346_line1.paf > utig4-2468_hap2_346_line1_patch.paf
sed -n '1p' hap2_346_hap2_346_line1.paf > hap2_346_hap2_346_line1_patch.paf



# Convert paf to gaf

telo_1854:
sed s/de:f://g utig4-1854_utig4-1854_line1_patch.paf | awk -F "\t" '{ if (match($5, "-")) print $1"\t"$2"\t"$3"\t"$4"\t+\t<"$6"\t"$7"\t"$7-$9"\t"$7-$8"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21; else print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t>"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21 }' > utig4-1854_utig4-1854_line1_patch.gaf 
sed s/de:f://g utig4-2375_utig4-1854_line1_patch.paf | awk -F "\t" '{ if (match($5, "-")) print $1"\t"$2"\t"$3"\t"$4"\t+\t<"$6"\t"$7"\t"$7-$9"\t"$7-$8"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21; else print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t>"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21 }' > utig4-2375_utig4-1854_line1_patch.gaf

telo_2468:
sed s/de:f://g utig4-2468_hap2_346_line1_patch.paf | awk -F "\t" '{ if (match($5, "-")) print $1"\t"$2"\t"$3"\t"$4"\t+\t<"$6"\t"$7"\t"$7-$9"\t"$7-$8"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21; else print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t>"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21 }' > utig4-2468_hap2_346_line1_patch.gaf 
sed s/de:f://g hap2_346_hap2_346_line1_patch.paf| awk -F "\t" '{ if (match($5, "-")) print $1"\t"$2"\t"$3"\t"$4"\t+\t<"$6"\t"$7"\t"$7-$9"\t"$7-$8"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21; else print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t>"$6"\t"$7"\t"$8"\t"$9"\t"$10"\t"$11"\t"$12"\t"$13"\t"$15"\tdv:f:"$21"\tid:f:"1-$21 }' > hap2_346_hap2_346_line1_patch.gaf 


 
