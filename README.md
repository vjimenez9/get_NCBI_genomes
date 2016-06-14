# get_NCBI_genomes
This script allows downloaded from NCBI genome in fasta format and / or gff

This script has been tested on linux, ubuntu, and MacOS, and assumes that an internet connection and it is installed wget. 

for help:
 perl get_NCBI_genome.pl  -h
 perl get_NCBI_genome.pl  --help
 
 example exec:
 # without downloading, only shows the genomes available for taxaid: 10090
 perl bin/Perl/get_NCBI_genome.pl -t 10090  --only_show 
 
# Download the complete genomes of musculus organism in gff format.
perl bin/Perl/get_NCBI_genome.pl -o "musculus" --execute --only_show -f gff 
