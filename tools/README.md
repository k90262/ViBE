# PREPARING TRAINING DATA FOR CREATING LOWER-LEVEL ViBE CLASSIFIER

## Overview
> See [Figure 2 Workflow of building training and evaluation datasets.](https://academic.oup.com/bib/article/23/4/bbac204/6603436?login=true#366567026) in the paper. 

## Overcome
- Implement a strategy: 
	- For class which includes only 1 genome, we use this genome for training data set and simulate NGS reads via tool _DWGSIM_. But we just move 2 reads (OR named 2 reads of read-level validation set) into genome-level validation set for fine-tuning model later.
- So that this approach still makes all class *almost* (around 0.01% to 0.001% difference) the same reads number (training data size) for only-1-genome-in-class case happened.
- And we still have validation set for those classes which include no genomes on genome-level validation set.

## Summarize
- To generate training data and validation data for fine-tuning ViBE pre-trained model as lower-level classifier
	1. We should prepare 2 inputs:
		-  _families_of_nidovirales.txt_ 
		- _genomes_of_nidovirales.csv_
	2. Follow our steps.
	3. Then will get 3 outputs: 
		- _training data_
		- _read-level validation data_
		- _genome-level validation data_
- To evaluate those data we generated, we used them to fine-tune a pre-trained ViBE model with 2 inputs:
  - Training data set
  - Genome-level validation set (may mix some Read-level validation set once this class include only 1 genome)
- To evaluate those model we fine-tuned with our data, we followed description of section `Classification of novel virus subtype` in ViBE paper: Fine-tune our model without SARS-CoV-2 reference genome (GCF_009858895), then predict COVID-19 sample (SRR14403295).
	- Results from our family- and genus-level classifier are not good (64.9%, 18.8%) as the paper listed (82.3%, 82.1%). 
		|Taxon name             |No. of seqs. (%)   |No. of seqs. (%) in paper  |
		|-----------------------|-------------------|---------------------------|
		|RNA viruses (d)        |159668 (83.5%)     |174897 (91.4%)             |
		|Nidovirales (o)        |141684 (74.1%)     |157667 (82.4%)             |
		|Coronaviridae (f)      |**124201 (64.9%)** |157483 (82.3%)             |
		|Betacoronavirus (g)    |**35962 (18.8%)**  |156950 (82.1%)             |
		- Confidence cutoff: 0.9.
		- total SRA reads (cleaned): 191265
		- Those biases may depend on 
			1. which genomes we pick up as training data or validation data at this time.
			2. on genus-level, we put ~5 unknown genomes as a new class 'Unknown'.
	- Surprisingly, we can get a better outcome if we put all the SRA data into a lower-level classifier. (Input data do not be filtered out from top-level classifiers)
		|Taxon name             |No. of seqs. (%)   |No. of seqs. (%) in paper  |
		|-----------------------|-------------------|---------------------------|
		|Coronaviridae (f)      |**153951 (80.5%)** |157483 (82.3%)             |
		- Confidence cutoff: 0.9.

## Methods and Materials

### I. PREPARE TRAINING DATA TASKS 

Below is a case of creating both of training dataset and validation dataset for fine-tuning a family-level classifier of Nidovirales.

#### PREREQUISITES 

##### A. INSTALL REQUIRED TOOLS
1. [ViBE conda env.](https://github.com/k90262/ViBE?tab=readme-ov-file#11-build-environment)
2. [DWGSIM](https://github.com/nh13/DWGSIM) 
	- (Please add this tool folder into your ENV. path)
3. [NCBI Datasets CLI](https://www.ncbi.nlm.nih.gov/datasets/docs/v2/download-and-install/)
4. Jim Kent/UCSC tool [faSomeRecords](http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/faSomeRecords)
	- (Please copy this tool into the folder included in ENV. path. e.g. `~/.local/bin`)
5. ADD `[your ViBE Project Root]\tools` INTO YOUR ENV. PATH 
	- For example (in Ubuntu 22.04):
		1. `vi ~/.bashrc`
		2. Add line `export PATH="[your ViBE Project Root]/tools:$PATH"` into the bottom of file. (Please replaced `[your ViBE Project Root]` into your real path of ViBE Tools folder)
> **TIPS**
>	- The result may looks like as below in `~/.bashrc` (if you update locally)
>		- For example:
>			```bash
>			...
>			export PATH="/mnt/d/Projects/DWGSIM:$PATH"
>			export PATH="/mnt/d/Projects/ViBE/tools:$PATH"
>			export PATH="$PATH:/home/ycho/.local/bin"
>			```
			Then, add permission to execute script or program:
			```
			# ViBE tools
			$ cd /mnt/d/Projects/ViBE/tools
			$ chmod +x *.pl *.sh
			
			# DWGSIM
			$ cd /mnt/d/Projects/DWGSIM
			$ chmod +x dwgsim
			
			# faSomeRecords
			$ cd /home/ycho/.local/bin
			$ chmod +x faSomeRecords
			```
>	- Testing your installation via the below commands, and those calls will switch conda env. or will show tool information without any errors:
>		```bash
>		$ conda activate vibe
>		$ dwgsim -h
>		$ datasets download virus genome taxon -h
>		$ faSomeRecords
>		$ batch_create_folder.pl
>		```
##### B. PREPARE 2 INPUT FILES:
1. _families_of_nidovirales.txt_ - a list of family-level classes (Nidovirales)
	- for example:
		```bash
		$ mkdir family_level
		$ cd family_level
		$ cat <<HEREDOC > families_of_nidovirales.txt
		Arteriviridae
		Coronaviridae
		Cremegaviridae
		Euroniviridae
		Gresnaviridae
		Medioniviridae
		Mesoniviridae
		Mononiviridae
		Nanghoshaviridae
		Nanhypoviridae
		Olifoviridae
		Roniviridae
		Tobaniviridae
		Abyssoviridae
		HEREDOC
		```
2. _genomes_of_nidovirales.csv_ - a list of genomes of all family-level classes (Nidovirales)
	- get fasta and record from ncbi 
		1. get fasta (header + genome sequences) from ncbi virus
			- For example: 
				- Go the web page [NCBI Virus -> taxon name = Nidovirales](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Genome&VirusLineage_ss=Nidovirales,%20taxid:76804&utm_source=data-hub)
				- 	__Number of NCBI Virus Assembly of Nidovirales__: 152
				- Follow below steps to download .fasta file included 152 genomes (those fasta headers are included `accession id`, which will be used to do genome-level or read-level filting later):
					```markdown
					# DATA README

					## Dowload web page link (with filter condition: taxid:76804 & SeqType: genome) 
					[NCBI Virus -> taxon name = Nidovirales](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Genome&VirusLineage_ss=Nidovirales,%20taxid:76804&utm_source=data-hub)

					## Download steps
					1. __Select all checkbox of 152 records__
					2. Click `Download` Button on the page.
					3. In Download options, choose:
						- Step 1 of 3: Select Data Type
							- Sequence Data(FASTA format)
								- `Nucleotide`
						- Step 2 of 3: Select Records
							- `Download Selected Records`
						- Step 3 of 3: Select FASTA definition line
							- `Build custom` 
								- Choose 5 fields only:  
									1. `Accession`, 
									2. `Assembly`, 
									3. `Family`, 
									4. `Genus`, 
									5. `Species`.
						- Click `Download`
					
					## Download Date
					2024.Nov.13

					## Reads Number
					152 (3.8M)

					## Others
					- `.fasta` -> Genome reads
					- `.acc` -> Accession List (Nucleotide)
					- `.csv` -> Results Table (CSV format)
					```
		2. created csv via downloaded FASTA definition line (fasta header): `Accession Assembly Family Genus Species`
			```bash
			$ cp YOUR_DOWNLOAD_PATH/sequences.fasta .	# copy fasta file into folder family_level/
			$ echo 'Accession,Assembly,Family,Genus,Species' > genomes_of_nidovirales.csv
			$ grep '>' sequences.fasta | perl -pe 's/\|/,/g' >> genomes_of_nidovirales.csv

			# validation
			$ head genomes_of_nidovirales.csv
			```
			It will show the csv file as below:
			```csv
			Accession,Assembly,Family,Genus,Species
			>NC_054003.1 ,GCF_023124385.1,Coronaviridae,Alphacoronavirus,Alphacoronavirus sp.
			>NC_054004.1 ,GCF_023141795.1,Coronaviridae,Alphacoronavirus,Alphacoronavirus CHB25
			>NC_054015.1 ,GCF_023124615.1,Coronaviridae,Alphacoronavirus,Alphacoronavirus HKU33
			...
			```
	- mark each line of genome via adding `Used To` column
		- Use Excel (or other tool your prefer) to add 1 column `Used to`, then make your choice for each genome: Is it the genome belonged to the _genome-level validation set_,  or the _read-level training set or validation set_? Then mark it as either `Genome-level Validation Set` or `Training Set, Read-level Validation Set`.
		- For example: 
			1. Save `csv` into `xlsx` file, and start to mark it via Excel. (e.g. `genomes_of_nidovirales.csv.xlsx`)
			2. Add 1 column `Used to`, then mark `Training Set, Read-level Validation Set` OR `Genome-level Validation Set` for each record of genome.
			3. Then, save back into `csv` file. (e.g. `head genomes_of_nidovirales.csv`)
			- PS: Manully mark record `GCF_004133285.1` to family `Abyssoviridae`. OR this genome will have no family info.
		- Example of `genomes_of_nidovirales.csv` file (listed via `head genomes_of_nidovirales.csv`):
			```csv
			Accession Number,Assembly Number,Family,Genus,Species,Used To
			>NC_040711.1 ,GCF_004133285.1,Abyssoviridae,,Aplysia californica nido-like virus,"Training Set, Read-level Validation Set"
			>NC_028963.1 ,GCF_001501455.1,Arteriviridae,Betaarterivirus,Betaarterivirus chinrav 1,Genome-level Validation Set
			>NC_048210.1 ,GCF_012271595.1,Arteriviridae,,Rodent arterivirus,"Training Set, Read-level Validation Set"
			>NC_043487.1 ,GCF_003971765.1,Arteriviridae,Betaarterivirus,Betaarterivirus suid 1,"Training Set, Read-level Validation Set"
			...
			```
#### STEP 1. Download genomes from list for each folder/label 
1.  Call script
	```bash
	$ mkdir genomes
	$ cd genomes	# family_level/genomes
	$ batch_create_folder.pl -d ../families_of_nidovirales.txt
	```
	> NOTES: It will show error `Error: The taxonomy name 'abyssoviridae' is not a recognized virus taxon.` when downloading `Abyssoviridae` in script. So we shoud download it manually. (Please see the next step)
2. Manaully download if we cannot download genomes through a family taxon / id
	- For exmaple: `Abyssoviridae` (Get the assembly id from `genomes_of_nidovirales.csv.xlsx` methioned earlier)
		```bash
		$ cd Abyssoviridae	# family_level/genomes/Abyssoviridae
		$ cat <<HEREDOC > virus_accession_list.txt
		GCF_004133285.1
		HEREDOC
		$ datasets download genome accession --inputfile virus_accession_list.txt
		$ unzip ncbi_dataset.zip
		$ find . -name "*fna" ! -name "genomic.fna" -type f | xargs cat > ncbi_dataset/data/genomic.fna

		# validation
		$ grep -e "^>" ncbi_dataset/data/genomic.fna | wc -l	# 1 genome downloaded
		```
3. Manually filter out genome (e.g. seperated genomes for genome-level validation or read-level validation ) 
	1. Call _Jim Kent/UCSC tool_ via script `batch_create_folder.pl` with parameter `-s` (means that we split genomes by file `genomes_of_nidovirales.csv` with marks):
		```bash	
		$ cd ..	# family_level/genomes
		$ cp ../genomes_of_nidovirales.csv marked_genomes.csv 
		$ batch_create_folder.pl -s ../families_of_nidovirales.txt
		```
		- current tree structure (via command `tree . -L 2`)
			```
			.
			├── Abyssoviridae
			...
			│   ├── genome_level_validation_genomes.fasta
			│   ├── genome_level_validation_ids.txt
			...
			│   ├── read_level_genomes.fasta
			│   └── virus_accession_list.txt
			├── Arteriviridae
			...
			│   ├── genome_level_validation_genomes.fasta
			│   ├── genome_level_validation_ids.txt
			...
			│   └── read_level_genomes.fasta
			├── Coronaviridae
			...
			```
		- validate if some of size of _*/genome_level_validation_genomes.fasta_ are corrected or not (via command `ll *`)
			- For example: size nubmer != 0
				```
				...
				-rwxrwxrwx 1 ycho ycho   1593 Jan 16 08:24 README.md*
				-rwxrwxrwx 1 ycho ycho  86372 Jan 16 21:35 genome_level_validation_genomes.fasta*
				-rwxrwxrwx 1 ycho ycho     39 Jan 16 21:35 genome_level_validation_ids.txt*
				...
				-rwxrwxrwx 1 ycho ycho 852631 Jan 16 21:35 read_level_genomes.fasta*
				...
				```
			- But it's fine if this class has only 1 genome and it must mark as the training set. (we will move 2 simulate sequences/reads to validation set on STEP 5. )																	
#### STEP 2. Get the MAXIMUM number via the one of class folders included the smallest total genome size. 
- Count size for each genome, and we will pick up the smaller one `Nanghoshaviridae` AND size != 0 for next steps:
	```bash
	$ wc */read_level_genomes.fasta | sort
	```
	- Result:
		```
		190     206   13493 Nanghoshaviridae/read_level_genomes.fasta
		215     232   15311 Cremegaviridae/read_level_genomes.fasta
		220     236   15670 Olifoviridae/read_level_genomes.fasta
		262     277   18627 Nanhypoviridae/read_level_genomes.fasta
		264     281   18825 Gresnaviridae/read_level_genomes.fasta
		291     306   20699 Medioniviridae/read_level_genomes.fasta
		450     458   36432 Abyssoviridae/read_level_genomes.fasta
		590     598   41845 Mononiviridae/read_level_genomes.fasta
		775     816   55142 Euroniviridae/read_level_genomes.fasta
		1176    1193   83383 Roniviridae/read_level_genomes.fasta
		4054    4189  287551 Mesoniviridae/read_level_genomes.fasta
		4727    4902  334888 Arteriviridae/read_level_genomes.fasta
		8180    8441  580839 Tobaniviridae/read_level_genomes.fasta
		28725   29210 2037236 Coronaviridae/read_level_genomes.fasta
		50119   51345 3559941 total
		```
- Steps:
	```bash
	$ cd .. 	# family_level/
	
	# Generate folders
	$ batch_create_folder.pl families_of_nidovirales.txt
	
	# Generate Commands
	$ generate_script_to_run_dwgsim.pl -f training_reads genomes/*/read_level_genomes.fasta
				
	# Just pick up and run the smallest size one (e.g. `Cremegaviridae`) to get the minimum read number (it will be the MAXMUM number and will be used for each class to simulate training reads with the same number) ....
	$ test_dwgsim_and_uncompress.sh Nanhypoviridae/training_reads genomes/Nanhypoviridae/read_level_genomes.fasta -1 0.0 &> Nanhypoviridae/training_reads.log
	$ cat Nanhypoviridae/training_reads.log
	```
	- Result of `Nanhypoviridae/training_reads.log`. In this case, we can get the generated number: 2622 as our MAXIMUM reads number for each class.
		```log
		+ TESTDATADIR=Nanghoshaviridae/training_reads
		+ GIVEN_GENOME_AS_REF=genomes/Nanghoshaviridae/read_level_genomes.fasta
		+ NUM_OF_READ_PAIRS=-1
		+ ERROR_RATES=0.0
		+ PURPOSE_STR=test
		+ OPTION_OF_NUM_OF_READ_PAIRS='-N -1'
		+ '[' -1 == -1 ']'
		+ OPTION_OF_NUM_OF_READ_PAIRS=
		+ OUTPUT_PREFIX=read_level_genomes.fasta.test
		+ mkdir -p Nanghoshaviridae/training_reads
		+ dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 genomes/Nanghoshaviridae/read_level_genomes.fasta Nanghoshaviridae/training_reads/read_level_genomes.fasta.test
		[dwgsim_core] NC_046960.1 length: 13162
		[dwgsim_core] 1 sequences, total length: 13162
		[dwgsim_core] Currently on:
		[dwgsim_core] 2622
		[dwgsim_core] Complete!
		+ set +x
		/mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level/Nanghoshaviridae/training_reads /mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level

		Validation

		Paired-end reads generated:
		----------------------------
		Positive reads generated: 2622
		Negative reads generated: 2622
		Total reads generated: 5244

		Checking total read number (positive + negative) from each genome in reference fasta file:
		----------------------------
		5244 NC_046960.1

		/mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level
		```
#### STEP 3. Use this MAXIMUM number as the number of training sequences for each class. Then, simulate all NGS sequences for each class. 
- For exmpale: the MAXIMUM number = 2622
	```bash
	# In family_level/
	$ generate_script_to_run_dwgsim.pl -f training_reads -n 2622 genomes/*/read_level_genomes.fasta > generate.sh
	$ ./generate.sh

	# validation
	$ tree . -L 2 --gitignore		# optional
	$ head */training_reads.log 	# optional
	$ tail */training_reads.log
	```
#### STEP 4. Prepared validation data set (10% of MAXIMUM number for each class) via repeat similar steps as above
- Genome-level 
	```bash
	# In family_level/
	$ wc genomes/*/genome_level_validation_genomes.fasta | sort 	# just check if each fasta existed
	$ generate_script_to_run_dwgsim.pl -f validation_reads -n 262 -e 0.015 genomes/*/genome_level_validation_genomes.fasta > generate_validation_dataset.sh  	# 10% of 2622 -> 262
	$ ./generate_validation_dataset.sh

	# validation
	$ head */validation_reads.log
	$ tail */validation_reads.log
	```
- Read-level 
	```bash
	# In family_level/
	$ generate_script_to_run_dwgsim.pl -f validation_reads_read_level -n 262 -e 0.015 genomes/*/read_level_genomes.fasta > generate_validation_dataset_read_level.sh  	# 10% of 2622 -> 262
	$ ./generate_validation_dataset_read_level.sh

	# validation
	$ head */validation_reads_read_level.log
	$ tail */validation_reads_read_level.log
	```
#### STEP 5. Run ViBE `seq2kmer_doc` pre-process and ouput csv files, and label those csv for each folder/label. 
```bash
# In family_level/
$ nohup batch_create_folder.pl -p families_of_nidovirales.txt &> batch_preprocess_and_label.log &

# validation
$ tail -f batch_preprocess_and_label.log
# (Ctrl-C to leave `tail -f` mode)
$ ll */*/*.paired.label.csv
```
It will show the total outputs:
```
-rwxrwxrwx 1 ycho ycho 6668537 Jan 15 19:52 Abyssoviridae/training_reads/data.Abyssoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:52 Abyssoviridae/validation_reads/data.Abyssoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6663528 Jan 15 19:51 Arteriviridae/training_reads/data.Arteriviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  665880 Jan 15 19:51 Arteriviridae/validation_reads/data.Arteriviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757102 Jan 15 19:51 Arteriviridae/validation_reads_read_level/data.Arteriviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6664491 Jan 15 19:51 Coronaviridae/training_reads/data.Coronaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  666068 Jan 15 19:51 Coronaviridae/validation_reads/data.Coronaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757301 Jan 15 19:51 Coronaviridae/validation_reads_read_level/data.Coronaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6668899 Jan 15 19:51 Cremegaviridae/training_reads/data.Cremegaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  666229 Jan 15 19:51 Cremegaviridae/validation_reads/data.Cremegaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757704 Jan 15 19:51 Cremegaviridae/validation_reads_read_level/data.Cremegaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6667776 Jan 15 19:51 Euroniviridae/training_reads/data.Euroniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  666080 Jan 15 19:51 Euroniviridae/validation_reads/data.Euroniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757577 Jan 15 19:51 Euroniviridae/validation_reads_read_level/data.Euroniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6666937 Jan 15 19:51 Gresnaviridae/training_reads/data.Gresnaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:51 Gresnaviridae/validation_reads/data.Gresnaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6669334 Jan 15 19:51 Medioniviridae/training_reads/data.Medioniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  666293 Jan 15 19:51 Medioniviridae/validation_reads/data.Medioniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757762 Jan 15 19:52 Medioniviridae/validation_reads_read_level/data.Medioniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6664630 Jan 15 19:52 Mesoniviridae/training_reads/data.Mesoniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  665966 Jan 15 19:52 Mesoniviridae/validation_reads/data.Mesoniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757271 Jan 15 19:52 Mesoniviridae/validation_reads_read_level/data.Mesoniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6668787 Jan 15 19:52 Mononiviridae/training_reads/data.Mononiviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:52 Mononiviridae/validation_reads/data.Mononiviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6673518 Jan 15 19:52 Nanghoshaviridae/training_reads/data.Nanghoshaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:52 Nanghoshaviridae/validation_reads/data.Nanghoshaviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6669633 Jan 15 19:52 Nanhypoviridae/training_reads/data.Nanhypoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:52 Nanhypoviridae/validation_reads/data.Nanhypoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6663679 Jan 15 19:52 Olifoviridae/training_reads/data.Olifoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho      29 Jan 15 19:52 Olifoviridae/validation_reads/data.Olifoviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6662372 Jan 15 19:52 Roniviridae/training_reads/data.Roniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  665521 Jan 15 19:52 Roniviridae/validation_reads/data.Roniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  756980 Jan 15 19:52 Roniviridae/validation_reads_read_level/data.Roniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho 6665289 Jan 15 19:52 Tobaniviridae/training_reads/data.Tobaniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  666030 Jan 15 19:52 Tobaniviridae/validation_reads/data.Tobaniviridae.paired.label.csv*
-rwxrwxrwx 1 ycho ycho  757316 Jan 15 19:52 Tobaniviridae/validation_reads_read_level/data.Tobaniviridae.paired.label.csv*
```
- **IMPORTANT**: In this case, due to empties of 6 genome-level validation set existed, we SHOULD move 2 sequences from training set into genome-level validation set for each empty class (6 times). 
	> **NOTE**: Why choose 2 sequences, not 3 or 1? 
	>	- We hope to keep all number of training data per class on the same. So picking less number is better. 
	>	- Even if 2/262 is smaller than 10% for genome-level validation set requirement, its number is bigger than 1/262.
	- For example:
		```bash
		$ move_2_sequences_from_training_set_into_validation_set.sh Abyssoviridae
		move_2_sequences_from_training_set_into_validation_set.sh Gresnaviridae
		move_2_sequences_from_training_set_into_validation_set.sh Mononiviridae
		move_2_sequences_from_training_set_into_validation_set.sh Nanghoshaviridae
		move_2_sequences_from_training_set_into_validation_set.sh Nanhypoviridae
		move_2_sequences_from_training_set_into_validation_set.sh Olifoviridae
		```
	- Result: (via command `ll */*/*.paired.label.csv`)
		```
		-rwxrwxrwx 1 ycho ycho 6663449 Jan 15 20:51 Abyssoviridae/training_reads/data.Abyssoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5117 Jan 15 20:51 Abyssoviridae/validation_reads/data.Abyssoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666118 Jan 15 20:49 Abyssoviridae/validation_reads_read_level/data.Abyssoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6663528 Jan 15 20:48 Arteriviridae/training_reads/data.Arteriviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665880 Jan 15 20:48 Arteriviridae/validation_reads/data.Arteriviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665639 Jan 15 20:48 Arteriviridae/validation_reads_read_level/data.Arteriviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6664491 Jan 15 20:48 Coronaviridae/training_reads/data.Coronaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666068 Jan 15 20:48 Coronaviridae/validation_reads/data.Coronaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665816 Jan 15 20:48 Coronaviridae/validation_reads_read_level/data.Coronaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6668899 Jan 15 20:48 Cremegaviridae/training_reads/data.Cremegaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666229 Jan 15 20:48 Cremegaviridae/validation_reads/data.Cremegaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666162 Jan 15 20:48 Cremegaviridae/validation_reads_read_level/data.Cremegaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6667776 Jan 15 20:48 Euroniviridae/training_reads/data.Euroniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666080 Jan 15 20:48 Euroniviridae/validation_reads/data.Euroniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666066 Jan 15 20:48 Euroniviridae/validation_reads_read_level/data.Euroniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6661851 Jan 15 20:51 Gresnaviridae/training_reads/data.Gresnaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5115 Jan 15 20:51 Gresnaviridae/validation_reads/data.Gresnaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665954 Jan 15 20:48 Gresnaviridae/validation_reads_read_level/data.Gresnaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6669334 Jan 15 20:48 Medioniviridae/training_reads/data.Medioniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666293 Jan 15 20:48 Medioniviridae/validation_reads/data.Medioniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666218 Jan 15 20:48 Medioniviridae/validation_reads_read_level/data.Medioniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6664630 Jan 15 20:48 Mesoniviridae/training_reads/data.Mesoniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665966 Jan 15 20:48 Mesoniviridae/validation_reads/data.Mesoniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665798 Jan 15 20:48 Mesoniviridae/validation_reads_read_level/data.Mesoniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6663699 Jan 15 20:51 Mononiviridae/training_reads/data.Mononiviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5117 Jan 15 20:51 Mononiviridae/validation_reads/data.Mononiviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666156 Jan 15 20:48 Mononiviridae/validation_reads_read_level/data.Mononiviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6668428 Jan 15 20:51 Nanghoshaviridae/training_reads/data.Nanghoshaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5119 Jan 15 20:51 Nanghoshaviridae/validation_reads/data.Nanghoshaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666620 Jan 15 20:48 Nanghoshaviridae/validation_reads_read_level/data.Nanghoshaviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6664546 Jan 15 20:51 Nanhypoviridae/training_reads/data.Nanhypoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5116 Jan 15 20:51 Nanhypoviridae/validation_reads/data.Nanhypoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666241 Jan 15 20:48 Nanhypoviridae/validation_reads_read_level/data.Nanhypoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6658595 Jan 15 20:51 Olifoviridae/training_reads/data.Olifoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho    5113 Jan 15 20:51 Olifoviridae/validation_reads/data.Olifoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665641 Jan 15 20:48 Olifoviridae/validation_reads_read_level/data.Olifoviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6662372 Jan 15 20:49 Roniviridae/training_reads/data.Roniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665521 Jan 15 20:49 Roniviridae/validation_reads/data.Roniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665512 Jan 15 20:49 Roniviridae/validation_reads_read_level/data.Roniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho 6665289 Jan 15 20:49 Tobaniviridae/training_reads/data.Tobaniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  666030 Jan 15 20:49 Tobaniviridae/validation_reads/data.Tobaniviridae.paired.label.csv*
		-rwxrwxrwx 1 ycho ycho  665844 Jan 15 20:49 Tobaniviridae/validation_reads_read_level/data.Tobaniviridae.paired.label.csv*
		```
#### STEP 6. Randomly mix all csv into 3 outputs (.csv) : 1 training set, 1 validation set (genome-level), and 1 read-level validation set.
```bash
# In family_level/
$ collect_shuff_and_generate_csv_dataset.sh
```
####  DONE. GET 3 FINAL OUTPUT FILES.
```bash
$ ll *.dataset.csv
```
Result:
```
-rwxrwxrwx 1 ycho ycho 93336843 Jan  8 21:05 training_reads.dataset.csv*
-rwxrwxrwx 1 ycho ycho  5327910 Jan  8 21:05 validation_reads.dataset.csv*
-rwxrwxrwx 1 ycho ycho  9323508 Jan  8 21:05 validation_reads_read_level.dataset.csv*
```
- _training_reads.dataset.csv_ - training set*
- _validation_reads.dataset.csv_ - validation set (genome-level)*
- _validation_reads_read_level.dataset.csv_ validation set (read-level)
> \* It will be used to fine-tune model

### II. FINE-TUNE - Use Our Data to Fine-Tune ViBE Pre-Trained Model  

- Copy files into GPU server (e.g. GPU: 3080Ti, 16G VRAM, git-cloned ViBE in `~/Projects/myViBE`)
	- For example:
		```bash
		$ ssh YOUR_ACCOUNT@YOUR_SERVER_IP
		$ mkdir -p ~/Projects/myViBE/examples/fine-tune/family_level 
		$ exit
		$ scp *.dataset.csv YOUR_ACCOUNT@YOUR_SERVER_IP:~/Projects/myViBE/examples/fine-tune/family_level/.
		```
- On GPU server
	- For example:	
		```bash
		$ ll ~/Projects/myViBE/examples/fine-tune/family_level/.	# validate data existed
		$ cd ~/Projects/myViBE
		$ mv screenlog.0 screenlog.0.bak.$(date --iso-8601).00  	# backup screen log (optional)
		$ screen -RUDL	# avoid network connection dropped when do training (it will take arround 1 hours and 10 minutes via 3080Ti). Logs will save into `screenlog.0`. (optional)
		$ conda activate vibe
		$ export WORK_DIR=.
		export PRETRAINED_MODEL=$WORK_DIR/models/pre-trained
		export DATA_DIR=$WORK_DIR/examples/fine-tune/family_level
		export CACHE_DIR=$DATA_DIR/cached
		export TRAIN_FILE=$DATA_DIR/training_reads.dataset.csv
		export DEV_FILE=$DATA_DIR/validation_reads.dataset.csv
		export OUTPUT_DIR=$WORK_DIR/models/family_level.Nidovirales.250bp

		src/vibe fine-tune \
			--gpus 0 \
			--pre-trained_model $PRETRAINED_MODEL \
			--train_file $TRAIN_FILE \
			--validation_file $DEV_FILE \
			--output_dir $OUTPUT_DIR \
			--overwrite_output_dir \
			--cache_dir $CACHE_DIR \
			--max_seq_length 504 \
			--num_workers 20 \
			--num_train_epochs 4 \
			--eval_steps 80 \
			--per_device_batch_size 16 \
			--warmup_ratio 0.25 \
			--learning_rate 3e-5
			
		$ exit	# exit screen (optional)
		$ exit	# exit ssh
		```
		> Ref. about program screen saving log
			- [logging - Save Screen (program) output to a file - Stack Overflow](https://stackoverflow.com/questions/14208001/save-screen-program-output-to-a-file:)
		- Training result and validation score (genome-level)
			```log
			100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 9176/9176 [2:17:50<00:00,  1.11it/s]
			[INFO|trainer.py:1995] 2025-01-15 23:29:48,373 >> Saving model checkpoint to ./models/family_level.Nidovirales.250bp
			[INFO|configuration_utils.py:413] 2025-01-15 23:29:48,373 >> Configuration saved in ./models/family_level.Nidovirales.250bp/config.json
			[INFO|modeling_utils.py:1041] 2025-01-15 23:29:48,626 >> Model weights saved in ./models/family_level.Nidovirales.250bp/pytorch_model.bin
			[INFO|tokenization_utils_base.py:2033] 2025-01-15 23:29:48,626 >> tokenizer config file saved in ./models/family_level.Nidovirales.250bp/tokenizer_config.json
			[INFO|tokenization_utils_base.py:2039] 2025-01-15 23:29:48,626 >> Special tokens file saved in ./models/family_level.Nidovirales.250bp/special_tokens_map.json
			***** train metrics *****
			epoch                    =        4.0
			train_loss               =     0.4068
			train_runtime            = 2:17:50.58
			train_samples            =      36696
			train_samples_per_second =     17.748
			train_steps_per_second   =      1.109
			01/15/2025 23:29:48 - INFO - vibe_finetune - *** Evaluate ***
			[INFO|trainer.py:541] 2025-01-15 23:29:48,632 >> The following columns in the evaluation set  don't have a corresponding argument in `ViBEForSequenceClassification.forward` and have been ignored: seqid, forward, backward.
			[INFO|trainer.py:2243] 2025-01-15 23:29:48,636 >> ***** Running Evaluation *****
			[INFO|trainer.py:2245] 2025-01-15 23:29:48,636 >>   Num examples = 2108
			[INFO|trainer.py:2248] 2025-01-15 23:29:48,636 >>   Batch size = 16
			100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 132/132 [00:26<00:00,  4.98it/s]
			***** eval metrics *****
			epoch                   =        4.0
			eval_AUC                =      0.929
			eval_Accuracy           =     0.5802
			eval_F1-score           =     0.4299
			eval_loss               =     3.9497
			eval_precision          =     0.4085
			eval_recall             =     0.7587
			eval_runtime            = 0:00:27.28
			eval_samples            =       2108
			eval_samples_per_second =      77.25
			eval_steps_per_second   =      4.837
			```
### III. VALIDATE - Follow `Classification of novel virus subtype` section in paper to test our fine-tuned family-level classifier

1. Download SRA data via NCBI SRA toolkit
	- confirm that we re-trained ViBE without the SARS-CoV-2 reference genome (GCF_009858895) before. (we make it as a genome-level validation set)
	- prepared docker env. and use SRA toolkit container to download the COVID-19 sample (SRR14403295)
		- demoe env: WSL2
		- docker version: Docker Desktop (for using GPU on docker)
			https://docs.docker.com/desktop/wsl/#turn-on-docker-desktop-wsl-2
		- SRA toolkit guide (docker)
			https://github.com/ncbi/sra-tools/wiki/SRA-tools-docker
			```bash
			$ cd ..	# leave family_level folder
			$ mkdir novel_virus_subtype
			$ cd novel_virus_subtype/
			$ docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools prefetch SRR14403295
			$ docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -p SRR14403295
			```
			- Ref. https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump
2. Get maximun length and minimum length from fastq
	```bash
	# Get the maximum length and the minimum length of reads
	$ cat SRR14403295_*.fastq | perl -ne 'print $1, "\n" if /^[+]/ and /length=(\d+)/' | sort -un > RR14403295_both.fastq.len.txt
	$ head -1 RR14403295_both.fastq.len.txt
	$ tail -1 RR14403295_both.fastq.len.txt
	# max: 251, min:35
	```
3. ViBE - Data processing (Please [download all ViBE model](https://github.com/k90262/ViBE/tree/tool/batch_create?tab=readme-ov-file#14-install-vibe-and-download-models) first, and go to the `models` folder and unzip `RNA250`. e.g. `tar -zxvf RNA250.tar.gz; tar -zxvf BPDR150.tar.gz`)
	```bash
	$ scp SRR14403295_*.fastq ycho@YOUR_SERVER_IP:~/Projects/myViBE/examples/SARS-CoV-2/.	# upload data into your GPU Server for preprocessing and predicting later
	$ ssh ycho@YOUR_SERVER_IP
	$ cd ~/Projects/myViBE
	$ conda activate vibe
	$ python scripts/seq2kmer_doc.py \
		-i examples/SARS-CoV-2/SRR14403295_1.fastq \
		-p examples/SARS-CoV-2/SRR14403295_2.fastq \
		-o examples/SARS-CoV-2/SRR14403295.demo.paired.csv \
		-k 4 \
		-f fastq \
		--min-length 200 \
		--max-length 251
	$ grep -v 'N' SRR14403295.demo.paired.csv > SRR14403295.demo.clean.paired.csv       	# `... Reads involving ambiguous calls (i.e. N) were removed. Only reads longer than 200 bp were used. `
	
	# validation
	$ wc -l examples/SARS-CoV-2/SRR14403295.demo.clean.paired.csv                        	# line number: 191266 (included header 1 and paired data 191265)
	```
4. ViBE - Domain-level classification
	```bash
	$ mv screenlog.0 screenlog.0.bak.$(date --iso-8601).01	# backup screen log (optional) 
	$ screen -RUDL                                       	# run screen to avoid connection dropped (optional) (it will take arround 30 minutes per classifying via 3080Ti)
	$ conda activate vibe
	$ export FINETUNED_MODEL=models/BPDR.250bp
	export DATA_DIR=examples/SARS-CoV-2
	export CACHE_DIR=$DATA_DIR/cached
	export SAMPLE_FILE=$DATA_DIR/SRR14403295.demo.clean.paired.csv
	export OUTPUT_DIR=$DATA_DIR/preds
	export OUTPUT_PREFIX=SRR14403295.domain

	src/vibe predict \
		--gpus 0 \
		--model $FINETUNED_MODEL \
		--sample_file $SAMPLE_FILE \
		--output_dir $OUTPUT_DIR \
		--output_prefix $OUTPUT_PREFIX \
		--cache_dir $CACHE_DIR \
		--per_device_batch_size 384 \
		--max_seq_length 504 \
		--num_workers 20
	# Pres `ctrl-a d` to detach session.
	# re-enter session via command `screen -RUDL`
	```
5. ViBE - Order-level classification
	- Get records classified as `RNA_viruses` with high confidence score over 0.9.
		```bash
		$ python scripts/split_data.py \
			-i examples/SARS-CoV-2/SRR14403295.demo.clean.paired.csv \
			-p examples/SARS-CoV-2/preds/SRR14403295.domain.txt \
			-o examples/SARS-CoV-2/ \
			-c 0.9 \
			-t RNA_viruses
		```	
	- The above command generates `RNA_viruses.cs`v file in the `examples/SARS-CoV-2` directory.
		```bash
		$ export FINETUNED_MODEL=models/RNA.250bp
		export DATA_DIR=examples/SARS-CoV-2
		export CACHE_DIR=$DATA_DIR/cached
		export SAMPLE_FILE=$DATA_DIR/RNA_viruses.csv
		export OUTPUT_DIR=$DATA_DIR/preds
		export OUTPUT_PREFIX=SRR14403295.RNA

		src/vibe predict \
			--gpus 0 \
			--model $FINETUNED_MODEL \
			--sample_file $SAMPLE_FILE \
			--output_dir $OUTPUT_DIR \
			--output_prefix $OUTPUT_PREFIX \
			--cache_dir $CACHE_DIR \
			--per_device_batch_size 384 \
			--max_seq_length 504 \
			--num_workers 20
		```
6. ViBE - Family-level classification
	- Get records classified as `Nidovirales` with high confidence score over 0.9.
		```bash
		$ python scripts/split_data.py \
			-i examples/SARS-CoV-2/RNA_viruses.csv \
			-p examples/SARS-CoV-2/preds/SRR14403295.RNA.txt \
			-o examples/SARS-CoV-2/ \
			-c 0.9 \
			-t Nidovirales
		```	
	- The above command generates `Nidovirales.cs`v file in the `examples/SARS-CoV-2` directory.
		```bash
		$ export FINETUNED_MODEL=models/family_level.Nidovirales.250bp
		export DATA_DIR=examples/SARS-CoV-2
		export CACHE_DIR=$DATA_DIR/cached
		export SAMPLE_FILE=$DATA_DIR/Nidovirales.csv
		export OUTPUT_DIR=$DATA_DIR/preds
		export OUTPUT_PREFIX=SRR14403295.Nidovirales

		src/vibe predict \
			--gpus 0 \
			--model $FINETUNED_MODEL \
			--sample_file $SAMPLE_FILE \
			--output_dir $OUTPUT_DIR \
			--output_prefix $OUTPUT_PREFIX \
			--cache_dir $CACHE_DIR \
			--per_device_batch_size 384 \
			--max_seq_length 504 \
			--num_workers 20
		```
	- Get records classified as `Coronaviridae` with high confidence score over 0.9.
		```bash
		$ python scripts/split_data.py \
			-i examples/SARS-CoV-2/Nidovirales.csv \
			-p examples/SARS-CoV-2/preds/SRR14403295.Nidovirales.txt \
			-o examples/SARS-CoV-2/ \
			-c 0.9 \
			-t Coronaviridae
		```
6. ViBE - Genus-level classification (Optional)
	> **NOTE**: We can follow this wiki steps to generate training data for Genus-level classifier of Coronaviridae. The differece are: (1. create folder `genus-level`, and (2. prepare 2 input `families_of_coronaviridae.txt`, `genomes_of_coronaviridae.csv` 
	- The above command generates `Coronaviridae.cs`v file in the `examples/SARS-CoV-2` directory.
		```bash
		$ export FINETUNED_MODEL=models/genus_level.Coronaviridae.250bp
		export DATA_DIR=examples/SARS-CoV-2
		export CACHE_DIR=$DATA_DIR/cached
		export SAMPLE_FILE=$DATA_DIR/Coronaviridae.csv
		export OUTPUT_DIR=$DATA_DIR/preds
		export OUTPUT_PREFIX=SRR14403295.Coronaviridae

		src/vibe predict \
			--gpus 0 \
			--model $FINETUNED_MODEL \
			--sample_file $SAMPLE_FILE \
			--output_dir $OUTPUT_DIR \
			--output_prefix $OUTPUT_PREFIX \
			--cache_dir $CACHE_DIR \
			--per_device_batch_size 384 \
			--max_seq_length 504 \
			--num_workers 20
		```
	- Get records classified as `Coronaviridae` with high confidence score over 0.9.
		```bash
		$ python scripts/split_data.py \
			-i examples/SARS-CoV-2/Coronaviridae.csv \
			-p examples/SARS-CoV-2/preds/SRR14403295.Coronaviridae.txt \
			-o examples/SARS-CoV-2/ \
			-c 0.9 \
			-t Betacoronavirus
		```
	- Exit screen (optional)
		```bash
		$ exit                                                	# exit screen (optional)
		```
8. **RESULT**: We can compare this result with table in section `Table 2. Classification results for COVID-19 sample by ViBE trained without SARS-CoV-2 reference genome` in the paper.
	|Taxon name             |No. of seqs. (%)   |No. of seqs. (%) in paper  |
	|-----------------------|-------------------|---------------------------|
	|RNA viruses (d)        |159668 (83.5%)     |174897 (91.4%)             |
	|Nidovirales (o)        |141684 (74.1%)     |157667 (82.4%)             |
	|Coronaviridae (f)      |**124201 (64.9%)** |157483 (82.3%)             |
	|Betacoronavirus (g)    |**35962 (18.8%)**  |156950 (82.1%)             |
	- Currnet family-level classifier version: 14-class version (keep single-genome-only class in training data and mix genome-level-and-read-level in validation data)
	- Confidence cutoff: 0.9.
	- total SRA reads (cleaned): 191265
- **OTHER RESULT I**: Just use total SRA reads (cleaned) as input, and feed to family-level classifier of Nidovirales.
	|Taxon name             |No. of seqs. (%)   |No. of seqs. (%) in paper  |
	|-----------------------|-------------------|---------------------------|
	|Coronaviridae (f)      |**153951 (80.5%)** |157483 (82.3%)             |
	- Confidence cutoff: 0.9.
- **OTHER RESULT II**: Just use total SRA reads (cleaned) as input, and feed to genus-level classifier of Coronaviridae.
	|Taxon name             |No. of seqs. (%)   |No. of seqs. (%) in paper  |
	|-----------------------|-------------------|---------------------------|
	|Betacoronavirus (g)    |**62384 (32.6%)**  |156950 (82.1%)             |
	- Confidence cutoff: 0.9.
