rule bwa_mem2_mem:
	input:
		reads=["results/trimmed/{sample}_R1.fq.gz", "results/trimmed/{sample}_R2.fq.gz"],
		idx=multiext("genome/daphnia_pulex.fasta", ".amb", ".ann", ".bwt.2bit.64", ".pac"),
	output:
		"results/mapped/{sample}.bam",
	log:
		"logs/bwa_mem2/mem/{sample}.log",
	params:
		extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
		sort="none",
	threads: 8
	resources:
		mem_mb=10240,
		time="5:00:00"
	wrapper:
		"v3.0.0/bio/bwa-mem2/mem" # Uses bwa-mem2=2.2.1
