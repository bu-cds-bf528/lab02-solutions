#!/usr/bin/env nextflow

process DOWNLOAD {

    output:
    path("GCF_000005845.2_ASM584v2_genomic.fna.gz")

    script:
    """
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
    """

}

process GC_CONTENT {

    conda 'envs/biopython_env.yml'

    input:
    path(genome)

    output:
    path("gc_content.txt")

    script:
    """
    gc_content.py
    """
}


workflow {
    DOWNLOAD()
    GC_CONTENT(DOWNLOAD.out)

}