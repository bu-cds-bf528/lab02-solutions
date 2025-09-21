#!/usr/bin/env nextflow

process NCBI_DATASETS_CLI {
    label 'process_single'
    conda 'envs/ncbidatasets_env.yml'

    output:
    path('dataset/**/*.fna')

    shell:
    """
    datasets download genome accession GCF_000005845.2 --include genome
    unzip ncbi_dataset.zip -d dataset/
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
    NCBI_DATASETS_CLI()
    GENOME_STATS(NCBI_DATASETS_CLI.out)
    PRINT_GC(GENOME_STATS.out.gc_content)
    PRINT_LENGTH(GENOME_STATS.out.length)
}