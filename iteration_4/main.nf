#!/usr/bin/env nextflow

nextflow.enable.types = true

process DOWNLOAD {

    output:
    Path = file("GCF_000005845.2_ASM584v2_genomic.fna.gz")

    script:
    """
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
    """

}

process GC_CONTENT {

    conda 'envs/biopython_env.yml'

    input:
    genome: Path

    output:
    Path = file("gc_content.txt")

    script:
    """
    gc_content.py -i $genome -o gc_content.txt
    """

}

workflow {
    dl_genome = DOWNLOAD()
    gc_content_results = GC_CONTENT(dl_genome)

}