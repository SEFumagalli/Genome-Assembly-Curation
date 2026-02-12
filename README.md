# Genome Assembly and Curation Project

This repository contains **documentation**, **tutorials**, and **scripts** for performing **genome assembly** and **manual curation** using **[Verkko](https://github.com/marbl/verkko)** and **[Verkko-Fillet](https://github.com/jjuhyunkim/verkko-fillet/tree/main)**.    



---



### **GyrT2T Project** 
- **Bos (primigenius) indicus**
- This project will highlight the differences in Verkko assembly output when a variety of data types are used. 
- Using the best quality assembly, this project also highlights the improvements over the current **[NCBI RNASeq Gyr reference (NIAB-ARS_B.indTharparkar_mat_pri_1.0)](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_029378745.1/)**. 



---



### **Contents**
- `helper-scripts
	- read quality control
	- read statistics
	- assembly statistics
	- graphics

- `Verkko`
	- steps for running each assembly type
	- steps for rerunning after curation

- `Verkko-Fillet`
	- modified to run on **[SCINet's HPC Ceres](https://scinet.usda.gov/)
	- additional scripts extend file formatting for easier curation 

- `Assembly comparisons`
	- between Gyr Verkko assemblies
	- between current Gyr NCBI reference and best Verkko assembly
