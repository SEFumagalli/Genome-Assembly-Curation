# Genome Assembly and Curation Project

This repository contains **documentation**, **tutorials**, and **scripts** for performing **genome assembly** and **manual curation** using **[Verkko](https://github.com/marbl/verkko)** and **[Verkko-Fillet](https://github.com/jjuhyunkim/verkko-fillet/tree/main)**.    



---



### **GyrT2T Project** 
- **Bos (primigenius) indicus**
- This project will highlight the differences in Verkko assembly output when a variety of data types are used. 
- Using the best quality assembly, this project also highlights the improvements over the current **[NCBI RNASeq Gyr reference (NIAB-ARS_B.indTharparkar_mat_pri_1.0)](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_029378745.1/)**. 



---



### **Contents**
- `Assembly comparisons`
	- between Gyr Verkko assemblies
	- between current Gyr NCBI reference and best Verkko assembly
	- assembly statistics script
	- T2T contigs/scaffold bargraph script

- `Curation`
	- detailed steps on curation of gaps, rDNA, and telomeres of the Verkko assembly (HiFi-Duplex Trio Pore-C) and an alternate assembly (HiFi-Herro Pore-C)

- `Example Files`
	- files mentioned in scripts - for context

- `helper-scripts`
	- verkko-fillet_bypass
		- scripts that output similar results to Verkko-Fillet
	- path translation between Bandage and Verkko scripts
	- read statistics script
	- gap fixes conversion for Verkko scripts
	- rDNA conversion from morph to patch for Verkko script
	- Conkord script - counts copy number of genomic features

- `Verkko`
	- GraphAligner scripts

- `Verkko-Fillet`
	- verkko-fillet scripts
		- README - specifically for running Verkko-Fillet from a python script; includes several precursor steps
		- chromosome translation between assembly and reference script
		- notes including modifications to Verkko-Fillet scripts; including additional formatting and creation of tables, files, and graphics for easy curation
	- T2T contig/scaffold heatmaps - all assemblies concatenated into a single file
	- rDNA information saved as table and string for easy Bandage usage (this is now included in run_verkko_fillet.sh)

