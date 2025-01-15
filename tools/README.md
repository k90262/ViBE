# PREPARING TRAINING DATA FOR CREATING LOWER-LEVEL CLASSIFIER
- PREPARE TRAINING DATA TASKS (family-level case)
	- PREREQUISITES 
		- INSTALL REQUIRED TOOLS
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
			- TIPS
				- The result may looks like as below in `~/.bashrc`
					```.bashrc
					...
					export PATH="/mnt/d/Projects/DWGSIM:$PATH"
					export PATH="/mnt/d/Projects/ViBE/tools:$PATH"
					export PATH="$PATH:/home/ycho/.local/bin"
					```
				- Testing your installation via the below commands, and those calls will switch conda env. or will show tool information without any errors:
					```
					$ conda activate vibe
					$ dwgsim -h
					$ datasets download virus genome taxon -h
					$ faSomeRecords
					$ batch_create_folder.pl
					```
		- PREPARE 2 INPUT FILES:
			1. `families_of_nidovirales.txt` - a list of family-level classes (Nidovirales)
				- for example:
					```
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
			2. `genomes_of_nidovirales.csv` - a list of genomes of all family-level classes (Nidovirales)
				- get fasta and record from ncbi 
					1. get fasta (header + genome sequences) from ncbi virus
						- For example: Go the web page [NCBI Virus -> taxon name = Nidovirales](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Genome&VirusLineage_ss=Nidovirales,%20taxid:76804&utm_source=data-hub)
							- Number of NCBI Virus Assembly: 152
							- Follow below steps to download .fasta file included 152 genomes (those fasta headers are included `accession id`, which will be used to do genome-level or read-level filting later)
								```
								# DATA README

								## Dowload web page link (with filter condition: taxid:76804 & SeqType: genome) 
								https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Genome&VirusLineage_ss=Nidovirales,%20taxid:76804&utm_source=data-hub

								## Download options
								- Choose all checkbox of 152 records
								- Click `Download` Button on the page.
								- In Download options, choose:
									- Step 1 of 3: Select Data Type
										- Sequence Data(FASTA format)
											- Nucleotide
									- Step 2 of 3: Select Records
										- Download Selected Records
									- Step 3 of 3: Select FASTA definition line
										- Build custom 
											- Choose `Accession`, `Assembly`, `Family`, `Genus`, `Species` only
									
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
						```
						$ cp ~/Downloads/sequences.fasta .	# family_level/
						$ echo 'Accession,Assembly,Family,Genus,Species' > genomes_of_nidovirales.csv
						$ grep '>' sequences.fasta | perl -pe 's/\|/,/g' >> genomes_of_nidovirales.csv

						# validation
						$ head genomes_of_nidovirales.csv
						```
				- label each genome via adding `Used To` column
					- Use excel to add 1 column `Used to`, then make your choice for each genome: Is it the genome belonged to the genome-level validation set,  or the read-level training set or validation set?
					- For example: 
						- Save `csv` into `xlsx`, and label it via Excel. (e.g. `genomes_of_nidovirales.csv.xlsx`)
						- Add 1 column `Used to`, then make your choice for each genome. (`Training Set, Read-level Validation Set` OR `Genome-level Validation Set`)
						- Then, save back into `csv` file. (e.g. `head genomes_of_nidovirales.csv`)
						- Make family `Abyssoviridae` manually for `GCF_004133285.1`. OR this genome will have no family info.
					- Example of `genomes_of_nidovirales.csv` file (listed via `head genomes_of_nidovirales.csv`):
						```
						Accession Number,Assembly Number,Family,Genus,Species,Used To
						>NC_040711.1 ,GCF_004133285.1,Abyssoviridae,,Aplysia californica nido-like virus,"Training Set, Read-level Validation Set"
						>NC_028963.1 ,GCF_001501455.1,Arteriviridae,Betaarterivirus,Betaarterivirus chinrav 1,Genome-level Validation Set
						>NC_048210.1 ,GCF_012271595.1,Arteriviridae,,Rodent arterivirus,"Training Set, Read-level Validation Set"
						>NC_043487.1 ,GCF_003971765.1,Arteriviridae,Betaarterivirus,Betaarterivirus suid 1,"Training Set, Read-level Validation Set"
						>NC_040535.1 ,GCF_004130335.1,Arteriviridae,,Rodent arterivirus,"Training Set, Read-level Validation Set"
						>NC_038291.1 ,GCF_002816115.1,Arteriviridae,Betaarterivirus,Betaarterivirus suid 2,"Training Set, Read-level Validation Set"
						>NC_038292.1 ,GCF_002816135.1,Arteriviridae,Iotaarterivirus,Iotaarterivirus kibreg 1,"Training Set, Read-level Validation Set"
						>NC_038293.1 ,GCF_002816155.1,Arteriviridae,Epsilonarterivirus,Epsilonarterivirus hemcep,"Training Set, Read-level Validation Set"
						>NC_035127.1 ,GCF_002210535.1,Arteriviridae,Muarterivirus,Muarterivirus afrigant,"Training Set, Read-level Validation Set"
						```
	1. Download genomes from list for each folder/label (Done, 20241231)
		1.  Call script
			```
			$ mkdir genomes
			$ cd genomes	# family_level/genomes
			$ batch_create_folder.pl -d ../families_of_nidovirales.txt
			```
			> NOTES: It will show error `Error: The taxonomy name 'abyssoviridae' is not a recognized virus taxon.` when downloading `Abyssoviridae` in script. So we shoud download it manually. (Please see the next step)
		2. Manaul download if we cannot download genomes through a family taxon / id
			- For exmaple: `Abyssoviridae` (Get the assembly id from `genomes_of_nidovirales.csv.xlsx` methioned earlier)
				```
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
			1. Call _Jim Kent/UCSC tool_ via sript `batch_create_folder.pl` with parameter `-s`:
				```		
				$ cd ..	# family_level/genomes
				$ mv ../genomes_of_nidovirales.csv .
				$ batch_create_folder.pl -s ../families_of_nidovirales.txt
				```
				- current tree structure
					```
					$ tree . -L 2
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
	2. Get the MAXIMUM number via the one of class folders included the smallest total genome size. 
		- Count size for each genome, and we will pick up the smaller one `Cremegaviridae` AND size != 0 for next steps:
			```
			$ wc */read_level_genomes.fasta | sort
			```
			- Result:
				```
					  0       0       0 Abyssoviridae/read_level_genomes.fasta
					  0       0       0 Gresnaviridae/read_level_genomes.fasta
					  0       0       0 Mononiviridae/read_level_genomes.fasta
					  0       0       0 Nanghoshaviridae/read_level_genomes.fasta
					  0       0       0 Nanhypoviridae/read_level_genomes.fasta
					  0       0       0 Olifoviridae/read_level_genomes.fasta
					215     232   15311 Cremegaviridae/read_level_genomes.fasta
					291     306   20699 Medioniviridae/read_level_genomes.fasta
					775     816   55142 Euroniviridae/read_level_genomes.fasta
				   1176    1193   83383 Roniviridae/read_level_genomes.fasta
				   4054    4189  287551 Mesoniviridae/read_level_genomes.fasta
				   4727    4902  334888 Arteriviridae/read_level_genomes.fasta
				   8180    8441  580839 Tobaniviridae/read_level_genomes.fasta
				  28725   29210 2037236 Coronaviridae/read_level_genomes.fasta
				  48143   49289 3415049 total
				```
		- Steps:
			```
			$ cd .. 	# family_level/
			
			# Remove class in which the file size of read_level_genomes.fasta = 0
			$ cat <<HEREDOC > families_of_nidovirales.txt
			Arteriviridae
			Coronaviridae
			Cremegaviridae
			Euroniviridae
			Medioniviridae
			Mesoniviridae
			Roniviridae
			Tobaniviridae
			HEREDOC
			
			# Generate folders
			$ batch_create_folder.pl families_of_nidovirales.txt
			
			# Generate Commands
			$ generate_script_to_run_dwgsim.pl -f training_reads genomes/*/read_level_genomes.fasta
						
			# Just pick up and run the smallest size one (e.g. `Cremegaviridae`) to get the minimum read number (it will be the MAXMUM number and will be used for each class to simulate training reads with the same number) ....
			$ test_dwgsim_and_uncompress.sh Cremegaviridae/training_reads genomes/Cremegaviridae/read_level_genomes.fasta -1 0.0 &> Cremegaviridae/training_reads.log
			$ cat Cremegaviridae/training_reads.log
			```
			- Result of `Cremegaviridae/training_reads.log`. In this case, we can get the generated number: 2976 as our MAXIMUM reads number for each class.
				```
				+ TESTDATADIR=Cremegaviridae/training_reads
				+ GIVEN_GENOME_AS_REF=genomes/Cremegaviridae/read_level_genomes.fasta
				+ NUM_OF_READ_PAIRS=-1
				+ ERROR_RATES=0.0
				+ PURPOSE_STR=test
				+ OPTION_OF_NUM_OF_READ_PAIRS='-N -1'
				+ '[' -1 == -1 ']'
				+ OPTION_OF_NUM_OF_READ_PAIRS=
				+ OUTPUT_PREFIX=read_level_genomes.fasta.test
				+ mkdir -p Cremegaviridae/training_reads
				+ dwgsim -e 0.0 -E 0.0 -d 500 -s 50 -r 0.0 -y 0 -1 251 -2 251 genomes/Cremegaviridae/read_level_genomes.fasta Cremegaviridae/training_reads/read_level_genomes.fasta.test
				[dwgsim_core] NC_046961.1 length: 14939
				[dwgsim_core] 1 sequences, total length: 14939
				[dwgsim_core] Currently on:
				[dwgsim_core] 2976
				[dwgsim_core] Complete!
				+ set +x
				/mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level/Cremegaviridae/training_reads /mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level

				Validation

				Paired-end reads generated:
				----------------------------
				Positive reads generated: 2976
				Negative reads generated: 2976
				Total reads generated: 5952

				Checking total read number (positive + negative) from each genome in reference fasta file:
				----------------------------
				   5952 NC_046961.1

				/mnt/d/Data/ViBE_fine_tune_family_and_genra_data_demo/family_level
				```
	3. Use this MAXIMUM number as the number of training sequences for each class. Then, simulate all NGS sequences for each class. 
		- For exmpale: the MAXIMUM number = 2976
			```
			# In family_level/
			$ generate_script_to_run_dwgsim.pl -f training_reads -n 2976 genomes/*/read_level_genomes.fasta > generate.sh
			$ ./generate.sh

			# validation
			$ tree . -L 2 --gitignore
			$ head */training_reads.log
			$ tail */training_reads.log
			```
	4. Prepared validation data set (10% of MAXIMUM number for each class) via repeat similar steps as above
		- Genome-level 
			```
			# In family_level/
			$ wc genomes/*/genome_level_validation_genomes.fasta | sort 	# just check if each fasta existed
			$ generate_script_to_run_dwgsim.pl -f validation_reads -n 298 -e 0.015 genomes/*/genome_level_validation_genomes.fasta > generate_validation_dataset.sh  	# 10% of 2976 -> 298
			$ ./generate_validation_dataset.sh

			# validation
			$ head */validation_reads.log
			$ tail */validation_reads.log
			```
		- Read-level 
			```
			# In family_level/
			$ generate_script_to_run_dwgsim.pl -f validation_reads_read_level -n 298 -e 0.015 genomes/*/read_level_genomes.fasta > generate_validation_dataset_read_level.sh  	# 10% of 2976 -> 298
			$ ./generate_validation_dataset_read_level.sh

			# validation
			$ head */validation_reads_read_level.log
			$ tail */validation_reads_read_level.log
			```
	5. Run ViBE `seq2kmer_doc` pre-process and ouput csv files, and label those csv for each folder/label. 
		```
		# In family_level/
		$ nohup batch_create_folder.pl -p families_of_nidovirales.txt &> batch_preprocess_and_label.log &
		
		# validation
		$ tail -f batch_preprocess_and_label.log
		# (Ctrl-C to leave `tail -f` mode)
		```
	6. Randomly mix all csv into 3 outputs (.csv) : 1 training set, 1 validation set (genome-level), and 1 read-level validation set.
		```
		# In family_level/
		$ collect_shuff_and_generate_csv_dataset.sh
		```
		- output
			```
			$ ll *.dataset.csv
			-rwxrwxrwx 1 ycho ycho 93336843 Jan  8 21:05 training_reads.dataset.csv*
			-rwxrwxrwx 1 ycho ycho  5327910 Jan  8 21:05 validation_reads.dataset.csv*
			-rwxrwxrwx 1 ycho ycho  9323508 Jan  8 21:05 validation_reads_read_level.dataset.csv*
			```
- FINE-TUNE - Use Our Data to Fine-Tune ViBE Pre-Trained Model  
	- Copy files into GPU server (e.g. GPU: 3080Ti, 16G VRAM, git-cloned ViBE in `~/Projects/myViBE`)
		- For example:
			```
			$ ssh ycho@YOUR_SERVER_IP
			$ mkdir -p ~/Projects/myViBE/examples/fine-tune/family_level_demo 
			$ exit
			$ scp *.dataset.csv ycho@YOUR_SERVER_IP:~/Projects/myViBE/examples/fine-tune/family_level_demo/.
			```
	- On GPU server
		- For example:	
			```
			$ cd ~/Projects/myViBE
			$ screen -RUDL	# avoid network connection dropped when do training (it will take arround 1 hours and 10 minutes). Logs will save into `screenlog.0`.
			$ conda activate vibe
			
			#
			# Run fine-tune for creating BPDR model via given-as-example BPDR k-mers csv (ps. `--per_device_batch_size 16` to avoid CUDA out of memry on 3080Ti server (16 GB ram))
			#
			$ export WORK_DIR=.
			export PRETRAINED_MODEL=$WORK_DIR/models/pre-trained
			export DATA_DIR=$WORK_DIR/examples/fine-tune/family_level_demo
			export CACHE_DIR=$DATA_DIR/cached
			export TRAIN_FILE=$DATA_DIR/training_reads.dataset.csv
			export DEV_FILE=$DATA_DIR/validation_reads.dataset.csv
			export OUTPUT_DIR=$WORK_DIR/models/family_level_demo.Nidovirales.250bp

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
				
			$ exit	# exit screen
			$ exit	# exit ssh
			```
				- Ref. about program screen saving log
					- [logging - Save Screen (program) output to a file - Stack Overflow](https://stackoverflow.com/questions/14208001/save-screen-program-output-to-a-file:)
			- Training result and validation score (genome-level)
				```
				***** train metrics *****
				  epoch                    =        4.0
				  train_loss               =      0.371
				  train_runtime            = 1:31:48.89
				  train_samples            =      23808
				  train_samples_per_second =     17.287
				  train_steps_per_second   =       1.08
				01/13/2025 22:06:46 - INFO - vibe_finetune - *** Evaluate ***
				[INFO|trainer.py:541] 2025-01-13 22:06:46,609 >> The following columns in the evaluation set  don't have a corresponding argument in `ViBEForSequenceClassification.forward` and have been ignored: forward, backward, seqid.
				[INFO|trainer.py:2243] 2025-01-13 22:06:46,613 >> ***** Running Evaluation *****
				[INFO|trainer.py:2245] 2025-01-13 22:06:46,613 >>   Num examples = 2384
				[INFO|trainer.py:2248] 2025-01-13 22:06:46,613 >>   Batch size = 16
				100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 149/149 [00:30<00:00,  4.81it/s]
				***** eval metrics *****
				  epoch                   =        4.0
				  eval_AUC                =     0.8559
				  eval_Accuracy           =     0.5831
				  eval_F1-score           =     0.5268
				  eval_loss               =     3.5356
				  eval_precision          =     0.5217
				  eval_recall             =     0.5831
				  eval_runtime            = 0:00:31.71
				  eval_samples            =       2384
				  eval_samples_per_second =     75.158
				  eval_steps_per_second   =      4.697
				```
- VALIDATE - Follow `Classification of novel virus subtype` section in paper to test our fine-tuned family-level classifier
	1. Download SRA data via NCBI SRA toolkit
		- confirm that we re-trained ViBE without the SARS-CoV-2 reference genome (GCF_009858895) before. (we make it as a genome-level validation set)
		- prepared docker env. and use SRA toolkit container to download the COVID-19 sample (SRR14403295)
			- demoe env: WSL2
			- docker version: Docker Desktop (for using GPU on docker)
				https://docs.docker.com/desktop/wsl/#turn-on-docker-desktop-wsl-2
			- SRA toolkit guide (docker)
				https://github.com/ncbi/sra-tools/wiki/SRA-tools-docker
				```
				$ cd ..	# leave family_level folder
				$ mkdir novel_virus_subtype
				$ cd novel_virus_subtype/
				$ docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools prefetch SRR14403295
				$ docker run -t --rm -v $PWD:/output:rw -w /output ncbi/sra-tools fasterq-dump -p SRR14403295
				```
				- Ref. https://github.com/ncbi/sra-tools/wiki/HowTo:-fasterq-dump
	2. Get maximun length and minimum length from fastq
		```
		# Get the maximum length and the minimum length of reads
		$ cat SRR14403295_*.fastq | perl -ne 'print $1, "\n" if /^[+]/ and /length=(\d+)/' | sort -un > RR14403295_both.fastq.len.txt
		$ head -1 RR14403295_both.fastq.len.txt
		$ tail -1 RR14403295_both.fastq.len.txt
		# max: 251, min:35
		```
	3. ViBE - Data processing (Please [download all ViBE model](https://github.com/k90262/ViBE/tree/tool/batch_create?tab=readme-ov-file#14-install-vibe-and-download-models) first, and go to the `models` folder and unzip `RNA250`. e.g. `tar -zxvf RNA250.tar.gz; tar -zxvf BPDR150.tar.gz`)
		```
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
		```
		$ mv screenlog.0 screenlog.0.bak.$(date --iso-8601).00	# backup screen log (optional) 
		$ screen -RUDL                                       	# run screen to avoid connection dropped (optional)
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
		```
	5. ViBE - Order-level classification
		- Get records classified as `RNA_viruses` with high confidence score over 0.9.
			```
			python scripts/split_data.py \
				-i examples/SARS-CoV-2/SRR14403295.demo.clean.paired.csv \
				-p examples/SARS-CoV-2/preds/SRR14403295.domain.txt \
				-o examples/SARS-CoV-2/ \
				-c 0.9 \
				-t RNA_viruses
			```	
		- The above command generates `RNA_viruses.cs`v file in the `examples/SARS-CoV-2` directory.
			```
			export FINETUNED_MODEL=models/RNA.250bp
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
			```
			python scripts/split_data.py \
				-i examples/SARS-CoV-2/RNA_viruses.csv \
				-p examples/SARS-CoV-2/preds/SRR14403295.RNA.txt \
				-o examples/SARS-CoV-2/ \
				-c 0.9 \
				-t Nidovirales
			```	
		- The above command generates `Nidovirales.cs`v file in the `examples/SARS-CoV-2` directory.
			```
			export FINETUNED_MODEL=models/family_level_demo.Nidovirales.250bp
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
			```
			python scripts/split_data.py \
				-i examples/SARS-CoV-2/Nidovirales.csv \
				-p examples/SARS-CoV-2/preds/SRR14403295.Nidovirales.txt \
				-o examples/SARS-CoV-2/ \
				-c 0.9 \
				-t Coronaviridae
			```
		- Exit screen (optional)
			```
			$ exit                                                	# exit screen (optional)
			```
	7. RESULT: (On-Going, we can compare this result with table in section `Table 2. Classification results for COVID-19 sample by ViBE trained without SARS-CoV-2 reference genome` in the paper)
		|Taxon name         |No. of seqs. (%)   |No. of seqs. (%) in paper  |
		|-------------------|-------------------|---------------------------|
		|RNA viruses (d)    |159668 (83.5%)     |174897 (91.4%)             |
		|Nidovirales (o)    |141685 (74.1%)     |157667 (82.4%)             |
		|Coronaviridae (f)  |120715 (63.1%)     |157483 (82.3%)             |
		|Betacoronavirus (g)|?????? (??.?%)     |156950 (82.1%)             |

	8. Summary (TODO)