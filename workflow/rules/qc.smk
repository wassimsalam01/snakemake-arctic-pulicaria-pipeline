rule fastqc:
	input:
		"reads/{sample}_{read}.fastq.gz"
	output:
		html="results/qc/{sample}_{read}_fastqc.html",
		zip="results/qc/{sample}_{read}_fastqc.zip"
	params:
		extra="--quiet"
	log:
		"logs/fastqc/{sample}_{read}.log"
	threads: 1
	resources:
		mem_mb=1024,
		time="0:30:00"
	wrapper:
		"v3.0.0/bio/fastqc" # Uses fastqc=0.12.1

rule multiqc:
	input:
		fastqc=expand("results/qc/{sample}_{read}_fastqc.{ext}", sample=config['samples'], read=['1','2'], ext=['html','zip']),
	output:
		"results/qc/multiqc.html",
		directory("results/qc/multiqc_data"),
	params:
		extra="--data-dir",
	log:
		"logs/multiqc/multiqc.log",
	resources:
		mem_mb=1024,
		time="0:30:00"
	wrapper:
		"v3.0.0/bio/multiqc" # Uses multiqc=1.18

rule trim_galore:
	input:
		["reads/{sample}_1.fastq.gz", "reads/{sample}_2.fastq.gz"]
	output:
		fasta_fwd="results/trimmed/{sample}_R1.fq.gz",
		report_fwd="results/trimmed/reports/{sample}_R1_trimming_report.txt",
		fasta_rev="results/trimmed/{sample}_R2.fq.gz",
		report_rev="results/trimmed/reports/{sample}_R2_trimming_report.txt"
	threads: 1
	resources:
		mem_mb=2048,
		time="5:00:00"
	params:
		extra="--illumina -q 20",
	log:
		"logs/trim_galore/{sample}.trim_galore.log"
	wrapper:
		"v3.0.0/bio/trim_galore/pe" # Uses trim_galore=0.6.10

use rule fastqc as fastqc_trimmed with:
	input:
		"results/trimmed/{sample}_R{read}.fq.gz"
	output:
		html="results/qc_trimmed/{sample}_R{read}_fastqc.html",
		zip="results/qc_trimmed/{sample}_R{read}_fastqc.zip"
	log:
		"logs/fastqc/trimmed/{sample}_R{read}.log"
	resources:
		mem_mb=1024
	wrapper:
		"v2.13.0/bio/fastqc"

use rule fastqc as fastqc_trimmed with:
	input:
		"trimmed/{sample}_R{read}.fq.gz"
	output:
		html="qc/trimmed/{sample}_R{read}_fastqc.html",
		zip="qc/trimmed/{sample}_R{read}_fastqc.zip"
	log:
		"logs/fastqc/trimmed/{sample}_{read}_val_{read}.log"

use rule multiqc as multiqc_trimmed with:
	input:
		trimmed = expand("results/qc_trimmed/{sample}_R{read}_fastqc.{ext}", sample=config['samples'], read=['1','2'], ext=['html','zip'])
	output:
		"results/qc_trimmed/multiqc.html",
		directory("results/qc_trimmed/multiqc_data")
	log:
		"logs/multiqc/multiqc_trimmed.log"

rule qualimap:
	input:
		bam="results/mapped/filtered/{sample}.filtered.sorted.bam"
	output:
		directory("results/qualimap/{sample}")
	log:
		"logs/qualimap/{sample}.log"
	resources:
		mem_mb=4096,
		time="4:00:00"
	wrapper:
		"v3.0.0/bio/qualimap/bamqc" # Uses qualimap=2.2.2d
