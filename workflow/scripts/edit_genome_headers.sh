#!/bin/bash
sed -i -e 's/Daphnia pulex isolate KAP4 chromosome 10/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 10/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 11/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 11/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 12/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 12/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 1/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 1/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 2/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 2/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 3/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 3/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 4/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 4/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 5/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 5/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 6/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 6/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 7/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 7/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 8/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 8/g' \
       -e 's/Daphnia pulex isolate KAP4 chromosome 9/Arctic Daphnia pulicaria Lake SS1381 consensus genome chromosome 9/g' \
       -e 's/Daphnia pulex mitochondrion/Arctic Daphnia pulicaria mitochondrion/g' \
       -e 's/, ASM2113471v1/, Consensus Genome built from Daphnia pulex ASM2113471v1 assembly/g' arctic_daphnia_pulicaria.fasta
