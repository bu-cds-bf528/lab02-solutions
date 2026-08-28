#!/usr/bin/env nextflow

nextflow.enable.types = true

process NCBI_DATASETS_CLI {
    label 'process_single'
    conda 'envs/ncbidatasets_env.yml'

    output:
    Path = file('dataset/**/*.fna')

    shell:
    """
    datasets download genome accession GCF_000005845.2 --include genome
    unzip ncbi_dataset.zip -d dataset/
    """
}

process GENOME_STATS {
    
    conda 'envs/biopython_env.yml'

    input:
    genome: Path

    output:
    length: Path = file('length.txt')
    gc_content: Path = file('gc_content.txt')

    script:
    """
    genome_stats.py -i $genome -g gc_content.txt -l length.txt
    """

}

process PRINT_GC {

    input:
    gc: Path

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
    length: Path

    output:
    stdout

    script:
    """
    echo "Length"
    cat $length
    """

}


workflow {
    main:
    datasets = NCBI_DATASETS_CLI()
    stats = GENOME_STATS(datasets)
    gc_out = PRINT_GC(stats.gc_content)
    length_out = PRINT_LENGTH(stats.length)

    publish:
    length_out = stats.length
    gc_out = stats.gc_content
}

output {
    length_out {}

    gc_out {}
}