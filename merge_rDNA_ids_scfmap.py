## -------------------------------------------------------------------------------
## This file combines rDNA.fasta.fai and scfmap -> tsv file
## This file also creates a list of the utigs listed in tsv file,
## which can be used in Bandage --> txt file
## Lengths of both files can be seen in std output
## -------------------------------------------------------------------------------


import argparse
import pandas as pd

parser=argparse.ArgumentParser()

parser.add_argument("--ids", type=str, help='fasta.fai file path')
parser.add_argument("--scfmap", type=str, help='scfmap file path')
parser.add_argument("--table_output", type=str, help='table output file path')
parser.add_argument("--utig_output", type=str, help='utig list output file path')

args = parser.parse_args()

#call rDNA ids in as dataframe
ids = pd.read_csv(args.ids, delimiter='\t', index_col=[0], header=None)

#open and collect utig names from scfmap
scfs = {}
utigs = []
with open(args.scfmap, "r") as file:
    for f in file:
        if f.startswith('path'):
            #split line and grab utig name
            line_split = f.split(' ')  
            utig = line_split[2].split('_')

            #if utig starts with 'na' or 'hap'
            if utig[0] == 'na' or utig[0].startswith('hap'):
                utigs.append(utig[2].strip())
                scfs[line_split[1]] = utig[2].strip()
            else:
                utigs.append(utig[3].strip())
                scfs[line_split[1]] = utig[3].strip()

#create df from scfs dict and concatenate with ids
scfmap = pd.DataFrame.from_dict(scfs, orient='index')
df = pd.concat([ids, scfmap], axis=1)

#remove rows with no data other than a utig name
temp_df = df[df[1].isna()]
remove_utigs = temp_df[0].tolist()
utigs = [u for u in utigs if u not in remove_utigs]

#drop na rows and save
df = df.dropna()
df.to_csv(args.table_output + '.tsv', sep="\t", header=False)

#save utig list as is
with open(args.utig_output + '.txt', "w") as file:
    file.write('[%s]' % ', '.join(utigs))
file.close()

print('length of tsv=', len(df))
print('length of bandage list=', len(utigs))
