library(SeqArray)
library(SeqVarTools)
library(digest)

vcf.fn = snakemake@input[['vcf_in']]
hd = seqVCF_Header(vcf.fn)
seqVCF2GDS(vcf.fn, "results/vcfs/filtering/snps.index.gds", header = hd, verbose = T)
genofile = seqOpen("results/vcfs/filtering/snps.index.gds", readonly = F)

genofile_filt = isSNV(genofile, biallelic = TRUE)
seqSetFilter(genofile, variant.sel = genofile_filt, verbose = T)
seqSetFilterCond(genofile, maf = 0.05, missing.rate = 0L, .progress = T, verbose = T)
vcf.final = snakemake@output[['vcf_out']]
seqGDS2VCF(genofile, vcf.final)
seqClose(genofile)
