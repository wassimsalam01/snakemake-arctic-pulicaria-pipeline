rule replaceGTfield:
	input:
		vcf = "results/vcfs/filtering/all_filtered_seqarray.vcf"
	output:
		vcf = "results/vcfs/all_final.vcf"
	log:
		"logs/make_altref/replaceGTfield.log"
	conda:
		os.path.join(workflow.basedir,"envs/make_altref.yaml")
	resources:
		mem_mb = 500,
		time = "0:10:00"
	shell:
		"vcffilter -f 'AF > 0.5' {input.vcf} | cut -f -10 | sed s%././.%1% > {output.vcf} 2> {log}"

rule compressVCF:
	input:
		vcf = "results/vcfs/all_final.vcf"
	output:
		compressed = "results/vcfs/all_final.vcf.gz",
		index = "results/vcfs/all_final.vcf.gz.tbi"
	log:
		"logs/make_altref/compressVCF.log"
	conda:
		os.path.join(workflow.basedir,"envs/make_altref.yaml")
	resources:
		mem_mb = 1000,
		time = "0:05:00"
	threads: 4
	shell:
		"bgzip -c -@ {threads} {input.vcf} > {output.compressed} && tabix -f -p vcf {output.compressed} > {output.index} 2> {log}"
		
rule bcftools_consensus:
	input:
		ref = "genome/daphnia_pulex.fasta",
		vcf = "results/vcfs/all_final.vcf.gz",
		vcf_index = "results/vcfs/all_final.vcf.gz.tbi"
	output:
		"results/arctic_daphnia_pulicaria.fasta"
	log:
		"logs/make_altref/bcftools_consensus.log"
	conda:
		os.path.join(workflow.basedir,"envs/make_altref.yaml")
	resources:
		mem_mb = 5120,
		time = "0:30:00"
	shell:
		"bcftools consensus -f {input.ref} -o {output} {input.vcf}  2> {log}"

rule samtools_index_pulicaria:
	input:
		"results/arctic_daphnia_pulicaria.fasta" 
	output:
		"results/arctic_daphnia_pulicaria.fasta.fai"
	log:
		"logs/samtools/arctic_daphnia_pulicaria.faidx.log"
	wrapper:
		"v3.0.0/bio/samtools/faidx" # Uses samtools=1.18
