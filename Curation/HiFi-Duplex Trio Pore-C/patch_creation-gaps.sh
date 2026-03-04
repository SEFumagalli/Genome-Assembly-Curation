#created by Sarah E. Fumagalli

patch_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/assembly_patches"
verkko_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec"
verkko_fillet_dir="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec_verkko_fillet"

## --------------------------------------------------------------------------------------------------------------------------------------------

## Gaps 0-41 - see verkko2.2.1_hifi-duplex_tporec_verkko_fillet/graphAlignment/verkko_edited_initial_gaps.csv
 
 	gapId		gaps
	gapid_0		['utig4-1179', 'utig4-2384']
	gapid_1		['utig4-2463', 'utig4-2323']
	gapid_2		['utig4-2363', 'utig4-2496']
	gapid_3		['utig4-2500', 'utig4-273']
	gapid_4		['utig4-1917', 'utig4-1807']
	gapid_5		['utig4-705', 'utig4-2425']
	gapid_6		['utig4-2425', 'utig4-1532']
	gapid_7		['utig4-376', 'utig4-378']
	gapid_8		['utig4-1371', 'utig4-1369']
	gapid_9		['utig4-2374', 'utig4-315']
	gapid_10	['utig4-1363', 'utig4-443']
	gapid_11	['utig4-443', 'utig4-2489']
	gapid_12	['utig4-1928', 'utig4-1473']
	gapid_13	['utig4-613', 'utig4-2485']
	gapid_14	['utig4-748', 'utig4-751']
	gapid_15	['utig4-2206', 'utig4-2266']
	gapid_16	['utig4-816', 'utig4-2468']
	gapid_17	['utig4-2200', 'utig4-1215']
	gapid_18	['utig4-1215', 'utig4-1831']
	gapid_19	['utig4-1831', 'utig4-2168']
	gapid_20	['utig4-808', 'utig4-1535']
	gapid_21	['utig4-376', 'utig4-378']
	gapid_22	['utig4-2010', 'utig4-1772']
	gapid_23	['utig4-2206', 'utig4-2266']
	gapid_24	['utig4-1346', 'utig4-1342']
	gapid_25	['utig4-1342', 'utig4-1523']
	gapid_26	['utig4-1669', 'utig4-1351']
	gapid_27	['utig4-1352', 'utig4-1893']
	gapid_28	['utig4-2396', 'utig4-2170']
	gapid_29	['utig4-2170', 'utig4-2255']
	gapid_30	['utig4-2401', 'utig4-2482']
	gapid_31	['utig4-2480', 'utig4-2427']
	gapid_32	['utig4-2427', 'utig4-1288']
	gapid_33	['utig4-2023', 'utig4-1389']
	gapid_34	['utig4-1543', 'utig4-1552']
	gapid_35	['utig4-1411', 'utig4-929']
	gapid_36	['utig4-1873', 'utig4-2111']
	gapid_37	['utig4-2430', 'utig4-2440']
	gapid_38	['utig4-2375', 'utig4-1854']
	gapid_39	['utig4-2389', 'utig4-2340']
	gapid_40	['utig4-621', 'utig4-2477']
	gapid_41	['utig4-2477', 'utig4-49']






	Find each gap in Bandage - multiple gaps may be located near one another -> use ; between names
	If a gap needs more work (eg. alignment), use NA for the path as shown below for gapid_5 

	Example gap_fixes.txt:

	gapid_0;gapid_1;gapid_2;gapid_3
	utig4-1179+,utig4-2384+,utig4-2386+,utig4-2474+,utig4-2464-,utig4-2463+,utig4-2324-,utig4-2323+,utig4-2326+,utig4-2387+,utig4-2365-
	gapid_4
	utig4-1917+,utig4-1942-,utig4-1942-,utig4-1807-
	gapid_5
	NA


	Place gap_fixes.txt in your patch_dir - see /90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/verkko2.2.1_hifi-duplex_tporec_patch/gaps/gap_fixes.txt


	Determine best path by using these files and tool: 
	     - $verkko_dir/8-manualResolution/verkko.graphAlign_allONT.gaf
	     - $verkko_dir/assembly.homopolymer-compressed.noseq.telo_rdna.gfa
	     - $verkko_dir/assembly.colors.csv
	     - $verkko_dir/assembly.colors.telo_rdna.csv
	     - $verkko_dir/assembly.homopolymer-compressed.chr.csv
	     - $verkko_dir/2-processGraph/unitig-unrolled-hifi-resolved.noseq.gfa
	     - $verkko_dir/3-align/alns-ont.gaf
	     - $verkko_fillet_dir/graphAlignment/verkko_initial_gaps.csv
	     - tangle_traverser.sh
		- tool that helps navigate tangles/gaps using the utig4 or/and utig1 graphs
		- https://github.com/marbl/TTT
		- /project/cattle_genome_assemblies/packages/TTT



## Identify gap nodes in Bandage
	
	1) Open Bandage and load $verkko_dir/assembly.homopolymer-compressed.noseq.telo_rdna.gfa
	
		Load assembly.colors.csv
		Under Tools tab, in Settings check ON for Arrowheads in single node style under Graph appearance
		Click Draw Graph
		Load assembly.colors.telo_rdna.csv
		Load assembly.homopolymer-compressed.chr.csv
		Change the 3rd dropdown under Graph display from Color by CSV column to Custom colours
		Increase the font size, select Name, select Depth under Node Labels on the lefthand side

	
	2) Find path associated with gap 

		grep utig4-1179 assembly.path.tsv

			dam_compressed.k31.hapmer_from_utig4-1179       

			utig4-1179+,[N5000N:ambig_path],utig4-2384+,utig4-2385+,utig4-2474+,utig4-2464-,utig4-2463+,
			[N24833N:ambig_bubble],utig4-2323+,utig4-2327+,utig4-2387+,utig4-2364-,utig4-2363+,
			[N306434N:ambig_bubble],utig4-2496-,utig4-2498+,utig4-2500+,[N310403N:ambig_bubble],utig4-273+,utig4-276+   


			This path contains 4 gaps

			gapid_0         ['utig4-1179', 'utig4-2384']
		        gapid_1         ['utig4-2463', 'utig4-2323']
        		gapid_2         ['utig4-2363', 'utig4-2496']
        		gapid_3         ['utig4-2500', 'utig4-273']


	3) Clean up path for Bandage
		
		py file can be found /project/cattle_genome_assemblies/config_files_scripts/Sarah_scripts/asm-path-translate-printout-Bandage.py or in verkko-fillet folder
			- this script can handle path formatting containing </>

		python3 asm-path-translate-printout-Bandage.py 'utig4-1179+,[N5000N:ambig_path],utig4-2384+,utig4-2385+,utig4-2474+,utig4-2464-,utig4-2463+,[N24833N:ambig_bubble],utig4-2323+,utig4-2327+,utig4-			2387+,utig4-2364-,utig4-2363+,[N306434N:ambig_bubble],utig4-2496-,utig4-2498+,utig4-2500+,[N310403N:ambig_bubble],utig4-273+,utig4-276+'
	
		Converted path:
		utig4-1179+,utig4-2384+,utig4-2385+,utig4-2474+,utig4-2464-,utig4-2463+,utig4-2323+,utig4-2327+,utig4-2387+,utig4-2364-,utig4-2363+,utig4-2496-,utig4-2498+,utig4-2500+,utig4-273+,utig4-276+
	


	4) Highlight nodes in Bandage
		
		highlight 'Converted path' output and copy into Bandage on the upper right under Find nodes 1st row 
		zoom into the area and move around the nodes so that all the gaps can be seen
		
		- this section of the graph shows many nodes in a loop
			- some nodes ~35x and some ~60x
			- the nodes with the higher coverage are expected to be used each time the loop is passed
			- the nodes with the lower coverage are expected to be used only once 
		


	5) Identify utig1 graph nodes (many not be necessary)
	
		if verkko-fillet has been run on your assembly, utig4_2_utig1 was created

		if not, run
		
			python3 /project/cattle_genome_assemblies/packages/verkkoPostASMScripts/utig4_to_utig1.py $verkko_dir > $verkko_dir/8-manualResolution/tangle_traverser/utig4_2_utig1
	

		grep utig4-1179 utig4_2_utig1

			<utig1-896<utig1-893_2>utig1-895<utig1-7128_2>utig1-7130>utig1-11003_1<utig1-10069<utig1-10066_2>utig1-10068>utig1-12123_1>utig1-12124>utig1-12456_2
			>utig1-12458>utig1-15852_1>utig1-15853<utig1-17230_1<utig1-5338>utig1-5339<utig1-16809<utig1-6027<utig1-6025>utig1-6024_2>utig1-12286_2>utig1-12289
			>utig1-12732_2<utig1-7322<utig1-7318_1>utig1-7319<utig1-16531<utig1-10642>utig1-10641_1<utig1-8181<utig1-8178_1>utig1-8179>utig1-12901_2<utig1-12539
			>utig1-12538_1>utig1-12540>utig1-13683_1>utig1-13684>utig1-15333_1<utig1-9803<utig1-9801_2<utig1-5784>utig1-5783_1<utig1-4587>utig1-4585_2>utig1-4589
			>utig1-13007_2<utig1-12520>utig1-12518_2<utig1-9644>utig1-9643_1<utig1-8027<utig1-8025_2<utig1-6885<utig1-6882_1>utig1-6883<utig1-16613_2>utig1-16615
			<utig1-16613_1>utig1-16614<utig1-17197<utig1-16186 

		

		python3 /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/asm-path-translate-printout-Bandage.py '<utig1-896<utig1-893_2>utig1-895<utig1-7128_2
			>utig1-7130>utig1-11003_1<utig1-10069<utig1-10066_2>utig1-10068>utig1-12123_1>utig1-12124>utig1-12456_2>utig1-12458>utig1-15852_1>utig1-15853<utig1-17230_1
			<utig1-5338>utig1-5339<utig1-16809<utig1-6027<utig1-6025>utig1-6024_2>utig1-12286_2>utig1-12289>utig1-12732_2<utig1-7322<utig1-7318_1>utig1-7319<utig1-16531
			<utig1-10642>utig1-10641_1<utig1-8181<utig1-8178_1>utig1-8179>utig1-12901_2<utig1-12539>utig1-12538_1>utig1-12540>utig1-13683_1>utig1-13684>utig1-15333_1
			<utig1-9803<utig1-9801_2<utig1-5784>utig1-5783_1<utig1-4587>utig1-4585_2>utig1-4589>utig1-13007_2<utig1-12520>utig1-12518_2<utig1-9644>utig1-9643_1
			<utig1-8027<utig1-8025_2<utig1-6885<utig1-6882_1>utig1-6883<utig1-16613_2>utig1-16615<utig1-16613_1>utig1-16614<utig1-17197<utig1-16186'	

                
		Converted path:
			utig1-896,utig1-893,utig1-895,utig1-7128,utig1-7130,utig1-11003,utig1-10069,utig1-10066,utig1-10068,utig1-12123,utig1-12124,utig1-12456,utig1-12458,
			utig1-15852,utig1-15853,utig1-17230,utig1-5338,utig1-5339,utig1-16809,utig1-6027,utig1-6025,utig1-6024,utig1-12286,utig1-12289,utig1-12732,utig1-7322,
			utig1-7318,utig1-7319,utig1-16531,utig1-10642,utig1-10641,utig1-8181,utig1-8178,utig1-8179,utig1-12901,utig1-12539,utig1-12538,utig1-12540,utig1-13683,
			utig1-13684,utig1-15333,utig1-9803,utig1-9801,utig1-5784,utig1-5783,utig1-4587,utig1-4585,utig1-4589,utig1-13007,utig1-12520,utig1-12518,utig1-9644,
			utig1-9643,utig1-8027,utig1-8025,utig1-6885,utig1-6882,utig1-6883,utig1-16613,utig1-16615,utig1-16613,utig1-16614,utig1-17197,utig1-16186

		
		since there are many more utig1 nodes, I usually find the last one - utig1-16186

		open a new Bandage and load $verkko_dir/2-processGraph/unitig-unrolled-hifi-resolved.gfa.noseq.gfa
		
		highlight the Converted path and copy into Bandage - color nodes on the bottom right
		



## Determine path traversal

	use $verkko_dir/8-manualResolution/verkko.graphAlign_allONT.gaf to idenify the path with the most read support
	use $verkko_dir/3-align/alns-ont.gaf for HiFi reads

	1) Manual curation

		when looking at the Bandage plot, utig4-1179 is only connnected to utig4-2384 - and so there is only one path to choose
		from utig4-2384, we can go to utig4-2385 or utig4-2386 - I usually choose the path with the greatest depth - utig4-2385
		there are also longer reads supporting the path utig4-1179,utig4-2384,utig4-2385,utig4-2474...... 

	
	2) Tangle Traverser (TTT)

		the boundaries should be from a single haplotype. 
		if both haplotypes exist as boundaries, include both in the boundaries file as two rows and two columns. 

		in our example with gapid_0-3, we might choose utig4-1179 and utig4-273 as our boundaries.
		though, when we look at the Bandage graph, we can more easily see that using utig4-1179 and utig4-276 is better because both boundaries are labeled the same haplotype - dam. 


		mkdir tangle_traverser
		cp /project/cattle_genome_assemblies/packages/TTT/tangle_traverser.sh .


		Before running you will need to make sure you have created these files:
			- utig4_upt.ont-coverage.csv
				
				python3 /project/cattle_genome_assemblies/packages/tangle_traverser/verkko_coverage_fix/utig4_coverage_updater.py $assembly/utig4_2_utig1 $assembly/assembly.homopolymer-						compressed.noseq.gfa $assembly/2-processGraph/unitig-unrolled-hifi-resolved.ont-coverage.csv > $assembly/utig4_upt.ont-coverage.csv

			- verkko.graphAlign_allONT.gaf
		
				- if verkko-fillet has already been run on your assembly, this file should be located in the 8-manualResolution folder of your verkko assembly
				- if not, follow these steps (also listed in /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/README_verkko-fillet on Ceres - step 9)
				
				cd verkko_directory
				
				mkdir 8-manualResolution (name formatting is important)

				cd 8-manualResolution/

				ln -s ../3-align/split .

				cp /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/graphalign_index.sh .

				cp /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/graphalign_align.sh .

				- for both sh files, change 'SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/' to your verkko directory
				- change '#SBATCH --array=1-198' in graphalign_align.sh, to match the number of aligned files in the split folder
				- run graphalign_index.sh
				- run graphalign_align.sh

				cat ont*.gaf > verkko.graphAlign_allONT.gaf

		

		tangle_traverser.sh

		#!/bin/bash -l

		#SBATCH --job-name=tangle_traverser-gapid_38
		#SBATCH --cpus-per-task=1
		#SBATCH --ntasks=1
		#SBATCH --mem-per-cpu=8000
		#SBATCH --partition=ceres
		#SBATCH --account=cattle_genome_assemblies
		#SBATCH --qos=agil
		#SBATCH --time=2:00:00
		#SBATCH --chdir=/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec/8-manualResolution/tangle_traverser/
		#SBATCH --output=tangle_traverser-gapid_38__%j.std
		#SBATCH --error=tangle_traverser-gapid_38__%j.err

		date

		assembly="/90daydata/ruminant_t2t/Gyr/assembly/verkko2.2.1_hifi-duplex_tporec"
		main_dir="/90daydata/ruminant_t2t/Gyr/assembly"

		micromamba activate tangle_traverser


		# Manual method
		#ONT
		python3 /project/cattle_genome_assemblies/packages/TTT/TTT.py \
			--graph $assembly/assembly.homopolymer-compressed.noseq.gfa \
			--alignment $assembly/8-manualResolution/verkko.graphAlign_allONT.gaf \
			--boundary-nodes nodes_boundaries/gapid_38.boundaries \
			--coverage $assembly/utig4_upt.ont-coverage.csv \
			--outdir tangle_traverser-manual-gapid_38


		#HiFi
		#python3 /project/cattle_genome_assemblies/packages/TTT/TTT.py \
		#        --graph $assembly/2-processGraph/unitig-unrolled-hifi-resolved.gfa \
		#        --alignment $assembly/3-align/alns-ont.gaf \
		#        --boundary-nodes nodes_boundaries/chr9_sire-utig1.boundaries \
		#        --coverage $assembly/2-processGraph/unitig-unrolled-hifi-resolved.ont-coverage.csv \
		#        --outdir tangle_traverser-chr9_sire-utig1




		TTT output:

			>utig4-1179>utig4-2384>utig4-2385>utig4-2474<utig4-2464>utig4-2463<utig4-2324>utig4-2323>utig4-2326>utig4-2387<utig4-2365>utig4-2363
			>utig4-2367<utig4-2496>utig4-2498>utig4-2500<utig4-275>utig4-273>utig4-277>utig4-2384>utig4-2386>utig4-2474<utig4-2465>utig4-2463
			<utig4-2325>utig4-2323>utig4-2327>utig4-2387<utig4-2364>utig4-2363>utig4-2366<utig4-2496>utig4-2497>utig4-2500<utig4-274>utig4-273>utig4-276




## Check the direction of your path in Bandage

	if your manual or TTT path uses >/<, these will need to be changed to the +/- format

	python3 /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/asm-path-translate-printout-reverse.py '>utig4-1179>utig4-2384>utig4-2385
	>utig4-2474<utig4-2464>utig4-2463<utig4-2324>utig4-2323>utig4-2326>utig4-2387<utig4-2365>utig4-2363>utig4-2367<utig4-2496>utig4-2498>utig4-2500<utig4-275
	>utig4-273>utig4-277>utig4-2384>utig4-2386>utig4-2474<utig4-2465>utig4-2463<utig4-2325>utig4-2323>utig4-2327>utig4-2387<utig4-2364>utig4-2363>utig4-2366
	<utig4-2496>utig4-2497>utig4-2500<utig4-274>utig4-273>utig4-276'

	Translated >/< path:
 	utig4-1179+,utig4-2384+,utig4-2385+,utig4-2474+,utig4-2464-,utig4-2463+,utig4-2324-,utig4-2323+,utig4-2326+,utig4-2387+,utig4-2365-,utig4-2363+,utig4-2367+,
	utig4-2496-,utig4-2498+,utig4-2500+,utig4-275-,utig4-273+,utig4-277+,utig4-2384+,utig4-2386+,utig4-2474+,utig4-2465-,utig4-2463+,utig4-2325-,utig4-2323+,
	utig4-2327+,utig4-2387+,utig4-2364-,utig4-2363+,utig4-2366+,utig4-2496-,utig4-2497+,utig4-2500+,utig4-274-,utig4-273+,utig4-276+


	in Bandage under the Output tab, click Specify exact path for copy/save

	copy the Translated path and paste 
		- if a valid path, a green check will show 
		- if not a valid path, a red x will show 



# For gaps that are more difficult, such as completely disconnected nodes --------------------------------------------------------------------------

	if an alignment is needed between your gap and another assembly for example, you will end up with gaf files.
	the gap needs two associated files, one alignment from each side of the gap.

	Example: gapid_38

	we treat these as 'patches' - see patch_creation-telo.sh for more details



# Missing telomeres that can be treated as gaps

	gapid	telomeres	chr	type	

	42	utig4-2457      9       sire
	43	utig4-1853	20	dam
	44	utig4-1864	19	dam
	

	check Bandage plot ONT graph
	
		- gapid_42 appears to have stopped early in the path and may share telomere with dam 
		- gapid_43 no telomere found at the end of utig4-1520
		- gapid_44 no telomere found at the end of utig4-820

	
	check Bandage plot HiFi graph

		- gapid_42 path exits to telomere utig4-2457
                - gapid_43 telomere does exist at the end of utig4-1520
                - gapid_44 telomere does exist at the end of utig4-820


	find supporting reads in HiFi data to create a path

		$verkko_dir/3-align/alns-ont.gaf

		- gapid_42 manually identified path to shared telomere utig4-2457
                - gapid_43 TTT found path to telomere utig4-1853
                - gapid_44 TTT found path to telomere utig4-1864


	check direction of path with Bandage as did above


	update $verkko_fillet_dir/graphAlignment/verkko_initial_gaps.csv with similar formatting

		- identify contig associated with utig that should have telomere
		- create boundaries (already done if used TTT)

		gapid_42,sire_compressed.k31.hapmer_from_utig4-2061,"['utig4-2061+', 'utig4-2457+']",,,,,,
		gapid_43,dam_compressed.k31.hapmer_from_utig4-734,"['utig4-1520+', 'utig4-1853+']",,,,,,
		gapid_44,dam_compressed.k31.hapmer_from_utig4-820,"['utig4-820+', 'utig4-1864+']",,,,,,



# Convert final paths in gap_fixes.txt to correct patch format (from -/+ to </>) for verkko


        run reformat_gapfixes_to_patches.sh

        python3 /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/reformat_gapfixes_to_patches.py --gap_fixes gap_fixes.txt --initial_gaps verkko_initial_gaps.csv

        output file name: converted_gap_fixes.tsv



# Manually (semi-automatic with below script) edit gap patch files

        Script can be found in Lee Ackerson github (https://github.com/LeeAckersonIV/genome-asm/tree/main/helper-scripts) or /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/addPatch.pl


        module load perl

        perl /project/cattle_genome_assemblies/config_files_scripts/verkko-fillet/addPatch.pl --gaf $verkko_dir/6-rukki/unitig-unrolled-unitig-unrolled-popped-unitig-normal-connected-tip.paths.gaf --patch $patch_dir/gaps/converted_gap_fixes.tsv > $patch_dir/gaps/gap.paths.gaf	

		
