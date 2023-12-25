#!/bin/bash

#SBATCH --job-name=daphnia
#SBATCH --mail-user=<YOUR-EMAIL>
#SBATCH --mail-type=END,FAIL
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --partition=<YOUR-PARTITION>
#SBATCH --mem=100MB
#SBATCH --time=1-12:00:00 
#SBATCH --qos=<YOUR-QOS>
#SBATCH --error=slurm/error/%x.%j.err
#SBATCH --output=slurm/output/%x.%j.out

eval "$(conda shell.bash hook)"

conda activate snakemake 

snakemake --profile slurm/ --unlock 
snakemake --forceall --dag | ~/miniforge3/pkgs/graphviz-9.0.0-h78e8752_1/bin/dot -Tpdf > docs/dag.pdf
snakemake --forceall --rulegraph | ~/miniforge3/pkgs/graphviz-9.0.0-h78e8752_1/bin/dot -Tpdf > docs/rulegraph.pdf
snakemake --forceall --report
snakemake --profile slurm/
