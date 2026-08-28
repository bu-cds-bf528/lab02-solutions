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
    txt: Path

    output:
    stdout

    script:
    """
    echo "GC Content"
    cat $txt
    """

}

process PRINT_LENGTH {

    input:
    txt: Path

    output:
    stdout

    script:
    """
    echo "Length"
    cat $txt
    """

}

workflow {
    main:
    dl_genome = DOWNLOAD()
    stats = GENOME_STATS(dl_genome)
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