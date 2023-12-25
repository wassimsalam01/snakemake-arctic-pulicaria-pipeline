# Snakemake Pipeline for Creating an Alternate Reference Genome: A Case Study on an Asexual Triploid Arctic _Daphnia pulicaria_ population

This workflow uses conda with Snakemake in order to create an alternate reference genome for a population of triploid _Daphnia pulicaria_ in West Greendland. For read mapping, the [genome assembly ASM2113471v1](https://www.ncbi.nlm.nih.gov/datasets/genome/GCF_021134715.1/) of _Daphnia pulex_ was used as reference.

## Abstract
A future study aims to take a closer look at methylation patterns throughout centuries in asexual triploid Arctic _Daphnia pulicaria_ strains. Its current proposal suggests using a _Daphnia pulex_ reference genome for mapping. This is possible since those strains belong to the larger _Daphnia pulex_ species complex, as well as due to the fact that _Daphnia pulex_ and _Daphnia pulicaria_ are known to be closely related and form hybrids. It must be noted that this project's Arctic _Daphnia pulicaria_ differentiate themselves from regular _Daphnia pulicaria_. They are classified in an entirely separate clade of their own, namely the  Polar _Daphnia pulicaria_ clade, by means of the the mitochondrial ND5 (Colbourne et al., 1998, Frisch).

This project puts forward the creation of an alternate reference genome unique to the Arctic _Daphnia pulicaria_ population of West Greenland, which is the main motivation. Another motivation is the establishment of a methodology to create an alternate reference genome for a triploid organism, seeing as most tools out there are adapted to diploids. It is theorized that using this newly created reference genome would yield better mapping and downstream analysis results in the future study, but has yet to be demonstrated.

For that, a customized Snakemake workflow was put together from Illumina 1.9 short-read Whole-Genome Sequencing (WGS) data of 10 _D. pulicaria_ samples, where individual eggs underwent Whole Genome Amplification (WGA) with the TruePrime Single Cell WGA Kit version 2.0. The workflow consists of five main steps: quality control, mapping, processing and cleaning of BAM files, variant calling and filtering, and lastly the creation of the alternate reference genome.

## How to use

1) Clone this repository using

```
git clone https://github.com/wassimsalam01/snakemake-triploid-alt-ref-genome-pipeline.git
```

2) Install miniforge in the home directory following the installation guide [here](https://github.com/conda-forge/miniforge#unix-like-platforms-mac-os--linux).
3) Install Snakemake following the installation guide [here](https://snakemake.readthedocs.io/en/stable/getting_started/installation.html).
4) Adjust values of `--mail-user`, `--partition` and `--qos` in `slurm/config.yaml` and in `snakemake.sh`.

5) Place PE reads in a directory named `reads`
6) Create Slurm output and error directories

```
cd slurm
mkdir slurm/output slurm/error
```

6) Test the workflow with a dry run

```
mamba activate snakemake
snakemake --profile slurm/ -n > dryrun.txt
```

7) Launch the workflow with

```
sbatch snakemake.sh
```

## Citations

J. K. Colbourne, T. J. Crease, L. J. Weider, P. D. N. Hebert, F. Duferesne, A. Hobæk, Phylogenetics and evolution of a circumarctic species complex (Cladocera: Daphnia pulex), Biological Journal of the Linnean Society, Volume 65, Issue 3, November 1998, Pages 347–365, [https://doi.org/10.1111/j.1095-8312.1998.tb01146.x](https://doi.org/10.1111/j.1095-8312.1998.tb01146.x)
