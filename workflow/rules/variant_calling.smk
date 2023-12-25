## Code adapted from freebayes repository
## https://github.com/freebayes/freebayes/blob/master/examples/snakemake-freebayes-parallel.smk
## as well as variant_calling.yaml 
## https://github.com/freebayes/freebayes/blob/master/examples/freebayes-env.yaml

nchunks = 5
CHUNKS = list(range(1, nchunks + 1))

rule generate_freebayes_regions:
	input:
		ref = "genome/daphnia_pulex.fasta",
		index = "genome/daphnia_pulex.fasta.fai"
	output:
		regions = expand("genome/regions/genome.{chrom}.region.{i}.bed", chrom = config["chroms"], i = CHUNKS)
	log:
		"logs/generate_freebayes_regions.log"
	params:
		chroms = config["chroms"],
		nchunks = nchunks
	conda:
		os.path.join(workflow.basedir,"envs/variant_calling.yaml")
	resources:
		mem_mb=1024,
		time = "00:10:00"
	shell:
		"python workflow/scripts/fasta_generate_regions.py {input.index} {params.nchunks} --chunks --bed genome/regions/genome --chromosomes {params.chroms} 2> {log}"

rule freebayes_variant_calling:
	input:
		bams = expand("results/mapped/dedup_bam/{sample}.bam", sample = config["samples"]),
		index = expand("results/mapped/dedup_bam/{sample}.bai", sample = config["samples"]),
		ref = "genome/daphnia_pulex.fasta",
		samples = config["bams"],
		regions = "genome/regions/genome.{chrom}.region.{i}.bed"
	output:
		"results/vcfs/calls/{chrom}/variants.{i}.vcf"
	log:
		"logs/freebayes/variant_calling/{chrom}.{i}.variant_calling_freebayes.log"
	conda:
		os.path.join(workflow.basedir,"envs/variant_calling.yaml")
	resources:
		mem_mb = 2048,
		time = "2:00:00"
	shell:
		"freebayes -f {input.ref} -t {input.regions} -L {input.samples} --min-mapping-quality 40 --min-base-quality 24 --min-alternate-fraction 0.01 --min-alternate-count 10 -p 3 -g 10000 > {output} 2> {log}"

rule concat_vcfs:
	input:
		calls = expand("results/vcfs/calls/{{chrom}}/variants.{i}.vcf", i = CHUNKS)
	output:
		"results/vcfs/calls_perChromosome/variants.{chrom}.vcf"
	log:
		"logs/freebayes/concat/{chrom}.concat_vcfs.log"
	conda:
		os.path.join(workflow.basedir,"envs/variant_calling.yaml")
	resources:
		mem_mb=1024,
		time = "0:30:00"
	threads:4
	shell:
		"bcftools concat --threads {threads} {input.calls} | vcfuniq > {output} 2> {log}"

rule concat_chrom_vcfs:
	input:
		expand("results/vcfs/calls_perChromosome/variants.{chrom}.vcf",chrom = config["chroms"])
	output:
		"results/vcfs/filtering/all.vcf"
	log:
		"logs/freebayes/concat_chrom_vcfs/concat_chrom_vcfs.log"
	conda:
		os.path.join(workflow.basedir,"envs/variant_calling.yaml")
	resources:
		mem_mb=1024,
		time = "0:15:00"
	threads:4
	shell:
		"bcftools concat --threads {threads} {input} | vcfuniq > {output} 2> {log}"
