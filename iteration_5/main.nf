#!/usr/bin/env nextflow

process DOWNLOAD {

    output:
    path("GCF_000005845.2_ASM584v2_genomic.fna.gz")

    script:
    """
    wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
    """

}

process GENOME_STATS {
    
    conda 'envs/biopython_env.yml'
    publishDir params.outdir

    input:
    path(genome)

    output:
    path('length.txt'), emit: length
    path('gc_content.txt'), emit: gc_content

    script:
    """
    genome_stats.py -i $genome -g gc_content.txt -l length.txt
    """

}

process PRINT_GC {

    input:
    path(gc)

    output:
    stdout

    script:
    """
    echo "GC Content"
    cat $gc
    """

}

process PRINT_LENGTH {

    input:
    path(length)

    output:
    stdout

    script:
    """
    echo "Length"
    cat $length
    """

}

workflow {
    DOWNLOAD()
    GENOME_STATS(DOWNLOAD.out)
    PRINT_GC(GENOME_STATS.out.gc_content)
    PRINT_LENGTH(GENOME_STATS.out.length)
}