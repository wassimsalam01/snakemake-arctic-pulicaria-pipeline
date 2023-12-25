rule samtools_view:
	input:
		"results/mapped/{sample}.bam",
	output:
		bam="results/mapped/filtered/{sample}.filtered.bam",
	log:
		"logs/samtools/view/{sample}.log",
	params:
		extra="-bh -F 2048",
	threads: 2
	wrapper:
		"v3.0.0/bio/samtools/view" # Uses samtools=1.18

rule samtools_sort:
	input:
		"results/mapped/filtered/{sample}.filtered.bam",
	output:
		"results/mapped/filtered/{sample}.filtered.sorted.bam",
	log:
		"logs/samtools/sort/{sample}.log",
	params:
		extra="-m 4G",
	threads: 8
	wrapper:
		"v3.0.0/bio/samtools/sort" # Uses samtools=1.18

rule picard_markduplicates:
	input:
		bams="results/mapped/filtered/{sample}.filtered.sorted.bam",
	output:
		bam="results/mapped/dedup_bam/{sample}.bam",
		bai="results/mapped/dedup_bam/{sample}.bai",
		metrics="results/mapped/dedup_bam/metrics/{sample}.metrics.txt",
	log:
		"logs/picard_markduplicates/{sample}.log",
	params:
		extra="--REMOVE_DUPLICATES true --CREATE_INDEX true --VALIDATION_STRINGENCY SILENT",
		java_opts = "-XX:ParallelGCThreads=10",
	resources:
		mem_mb=5120,
		time="3:00:00"
	wrapper:
		"v3.0.0/bio/picard/markduplicates" # Uses picard=3.3.1
