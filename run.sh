#!bin/bash
project=PRJNA13758
reference=WS255
prefix=ftp://ftp.wormbase.org/pub/wormbase/releases/${reference}/species/c_elegans/${project}/

# Download gene set
curl ${prefix}/c_elegans.${project}.${reference}.canonical_geneset.gtf.gz > data/c_elegans.${project}.${reference}.canonical_geneset.gtf

# Download reference genome
curl ${prefix}/c_elegans.${project}.${reference}.genomic.fa.gz > data/c_elegans.${project}.${reference}.genomic.fa.gz

gzcat data/c_elegans.${project}.${reference}.canonical_geneset.gtf | python hisat2_extract_splice_sites.py - > data/${reference}.ss
gzcat data/c_elegans.${project}.${reference}.canonical_geneset.gtf | python hisat2_extract_exons.py - > data/${reference}.exon

gzip -cd data/c_elegans.${project}.${reference}.genomic.fa.gz > data/c_elegans.${project}.${reference}.genomic.fa

hisat2-build -p 6 --ss data/${reference}.ss --exon data/${reference}.exon data/c_elegans.${project}.${reference}.genomic.fa data/${reference}.hisat2_index