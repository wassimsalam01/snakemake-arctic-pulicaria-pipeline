rule download_genome:
	output:
		"genome/daphnia_pulex.fasta"
	conda:
		os.path.join(workflow.basedir,"envs/genome.yaml")
	resources:
		mem_mb=1024,
		time="0:10:00"
	shell:
		"""
		curl -OJX GET "https://api.ncbi.nlm.nih.gov/datasets/v2alpha/genome/accession/GCF_021134715.1/download?include_annotation_type=GENOME_FASTA,SEQUENCE_REPORT&filename=GCF_021134715.1.zip" -H "Accept: application/zip"
		unzip GCF_021134715.1.zip
		mv ncbi_dataset/data/GCF_021134715.1/GCF_021134715.1_ASM2113471v1_genomic.fna genome/daphnia_pulex.fasta
		rm -r ncbi_dataset GCF_021134715.1.zip README.md
		"""

rule samtools_index_pulex:
	input:
		"genome/daphnia_pulex.fasta" 
	output:
		"genome/daphnia_pulex.fasta.fai"
	log:
		"logs/samtools/daphnia_pulex.faidx.log"
	resources:
		mem_mb=1024,
		time="0:10:00"
	wrapper:
		"v3.0.0/bio/samtools/faidx" # Uses samtools=1.18

rule bwa_mem2_index:
	input:
		"genome/daphnia_pulex.fasta",
	output:
		"genome/daphnia_pulex.fasta.0123",
		"genome/daphnia_pulex.fasta.amb",
		"genome/daphnia_pulex.fasta.ann",
		"genome/daphnia_pulex.fasta.bwt.2bit.64",
		"genome/daphnia_pulex.fasta.pac",
	log:
		"logs/bwa-mem2/index/bwa-mem2-index.log",
	resources:
		mem_mb=4092,
		time="0:30:00"
	wrapper:
		"v3.0.0/bio/bwa-mem2/index" # Uses bwa-mem2=2.2.1
