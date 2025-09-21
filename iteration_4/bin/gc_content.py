#!/usr/bin/env python

import argparse
from Bio import SeqIO
from Bio.SeqUtils import gc_fraction
import gzip

parser = argparse.ArgumentParser(description='Description of your script')
parser.add_argument('-i', dest='input', help='Description of input', required=True)
parser.add_argument('-o', dest='output', help='Name of output file', required=True)
args = parser.parse_args()

with gzip.open(args.input, 'rt') as f:
    record = SeqIO.read(f, 'fasta')

with open(args.output, 'wt') as w:
    w.write(f"{gc_fraction(record.seq)}")