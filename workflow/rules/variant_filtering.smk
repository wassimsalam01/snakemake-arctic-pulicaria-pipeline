rule filterSNPs:
	input:
		"results/vcfs/filtering/all.vcf"
	output:
		"results/vcfs/filtering/all_filtered.vcf"
	conda:
		os.path.join(workflow.basedir,"envs/variant_filtering.yaml")
	log:
		"logs/filtering/filterSNPs.log"
	resources:
		time = "0:30:00"
	shell:
		"vcffilter -f 'QUAL > 1 & QUAL / AO > 10 & SAF > 0 & SAR > 0 & RPR > 1 & RPL > 1' -g 'DP > 10' -t PASS {input} | vcffilter -f 'FILTER = PASS' > {output}"

rule selectSNPs:
	input:
		"results/vcfs/filtering/all_filtered.vcf"
	output:
		"results/vcfs/filtering/all_filtered_SNPs.vcf"
	conda:
		os.path.join(workflow.basedir,"envs/variant_filtering.yaml")
	log:
		"logs/filtering/selectSNPs.log"
	resources:
		time = "0:30:00"
	shell:
		"vcffilter -f 'TYPE = snp' {input} > {output}"

rule index_SNPsvcf:
	input:
		"results/vcfs/filtering/all_filtered_SNPs.vcf"
	output:
		"results/vcfs/filtering/all_filtered_index_SNPS.vcf"
	conda:
		os.path.join(workflow.basedir,"envs/variant_filtering.yaml")
	log:
		"logs/filtering/index_SNPsvcf.log"
	resources:
		time = "0:30:00"
	shell:
		"gatk SelectVariants -V {input} -select-type SNP -O {output}"
		
rule seq_array:
	input:
		vcf_in = "results/vcfs/filtering/all_filtered_index_SNPS.vcf"
	output:
		vcf_out = "results/vcfs/filtering/all_filtered_seqarray.vcf"
	log:
		"logs/filtering/seq_array.log"
	conda:
		os.path.join(workflow.basedir,"envs/variant_filtering.yaml")
	script:
		os.path.join(workflow.basedir,"scripts/seq_array.R")