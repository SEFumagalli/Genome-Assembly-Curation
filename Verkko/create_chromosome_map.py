import pandas as pd
import argparse
from Bio import SeqIO

parser=argparse.ArgumentParser()

parser.add_argument(
  "--chr_ids",
  help='chromosome ids',
)
parser.add_argument(
  "--chr_num",
  type=int
)


args = parser.parse_args()

data = args.chr_ids
chr_num = args.chr_num
print('number of chromosomes=',chr_num)

'''
cutoff = 0
chromos = []
contigs = []
with open(data, 'r') as file:
    for index, line in enumerate(file):
        if index > 0:
            line = line.strip()
            split1, split2 = line.split()
            slice1 = split1[:11]
            slice2 = split1[12:]
            chromos.append(slice2)
            contigs.append(slice1)

        if cutoff == 31:
            break
        else:
            cutoff += 1

df = pd.DataFrame([contigs, chromos])

df.T.to_csv('chromosome.map', sep="\t", header=False, index=False)
'''

def chromosome_map(data, chr_num):

    """
    #This function creates a pandas df with two columns: names and chromosomes

    #Outputs pandas df called map_file
    """

    chromos = []
    names = []
    index = 1
    with open(data, 'r') as file:
        for record in SeqIO.parse(file, 'fasta'):
            line = record.id
            if index > chr_num:
                break
            else:
                if index <= 9:
                    names.append(line[:-6])
                    chromos.append(line[-5:])
                if index > 9:
                    if line.endswith('X') or line.endswith('Y'):
                        names.append(line[:-6])
                        chromos.append(line[-5:])
                        if line.endswith('Y'):
                            break
                    else:
                        names.append(line[:-7])
                        chromos.append(line[-6:])

            index += 1

    map_file = pd.DataFrame([names, chromos]).T
    #map_file.to_csv(main_dir + 'chromosome.map', sep="\t", header=False, index=False)


    return map_file


map_file = chromosome_map(data, chr_num)
print(map_file)
