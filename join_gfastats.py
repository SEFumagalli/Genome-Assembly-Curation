## -----------------------------------------------------------------------
## This script collects each assembly's gfa haplotype stats and combines
## them in a single csv.
##
## Requirement: gfastats stat files created for each assembly
##
## Input for each assembly: haplotype1.fasta.stats
##                          haplotype2.fasta.stats
##
## Easily add or subtract the number of assemblies by adding or
## removing the number of lists and filenames (sh file), and
## arguments and file list (py file).
##
## Output: gfastats.csv
##         gfastats.png
## -----------------------------------------------------------------------


import pandas as pd
import sys
import argparse
import matplotlib.pyplot as plt


pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)

parser=argparse.ArgumentParser()

parser.add_argument("--lista", nargs="*", default=[])
parser.add_argument("--listb", nargs="*", default=[])
parser.add_argument("--listc", nargs="*", default=[])
parser.add_argument("--listd", nargs="*", default=[])
parser.add_argument("--liste", nargs="*", default=[])
parser.add_argument("--listf", nargs="*", default=[])
parser.add_argument("--listg", nargs="*", default=[])
parser.add_argument("--listh", nargs="*", default=[])
parser.add_argument("--listi", nargs="*", default=[])
parser.add_argument("--listj", nargs="*", default=[])
parser.add_argument("--listk", nargs="*", default=[])
parser.add_argument("--listl", nargs="*", default=[])
parser.add_argument("--listm", nargs="*", default=[])
parser.add_argument("--listn", nargs="*", default=[])
parser.add_argument("--listo", nargs="*", default=[])
parser.add_argument("--listp", nargs="*", default=[])
parser.add_argument("--listq", nargs="*", default=[])
parser.add_argument("--listr", nargs="*", default=[])
parser.add_argument("--lists", nargs="*", default=[])
parser.add_argument("--filenames", nargs="*")
parser.add_argument("--csvname", help='csv file name')
parser.add_argument("--graphname", help='Gyr_haplotype_scaffold_contig_plot')

args = parser.parse_args()


files = [args.lista, args.listb, args.listc, args.listd, args.liste, args.listf, args.listg, args.listh, args.listi,
        args.listj, args.listk, args.listl, args.listm, args.listn, args.listo, args.listp, args.listq, args.listr, args.lists]
file_names = args.filenames
csv_name = args.csvname
graph_name1 = args.graphname1


def bargraph(df, graph_name):
    """

    Creates N50 bar graph 

    """

    df = df.T
    ax = df['Contig N50'].plot(kind='barh', figsize=(8, 6), stacked=False, legend=False, title='Scaffold N50', xlabel='N50', ylabel='Assembly')
    plt.legend(loc=(1.02, 0.5))
    plt.savefig(graph_name + '.png', bbox_inches='tight')
    plt.close()



def divide_chunks(l, n):
    # looping till length l
    for i in range(0, len(l), n):
        yield l[i:i + n]


#read in stat files and combine data into dictionary
index_list = []
values_dict = {key: [] for key in file_names}
temp_hap_names = []
temp_assembly_names = []
counter = 0
for h,l in enumerate(files):
    for i,f in enumerate(l):
        temp_assembly_names.append(file_names[counter][:-4])
        if 'haplotype1' in f:
            temp_hap_names.append('Hap 1')
        else:
            temp_hap_names.append('Hap 2')
        with open(f, 'r') as file:
            for j, line in enumerate(file):
                if j > 0:
                    line = line.strip()
                    header, value = line.split(': ')
                    value = value.strip()
                    if 'Base composition' in header:
                        A_count, C_count, G_count, T_count = value.split(':')
                        if h == 0 and i == 0:
                            index_list.append('A count')
                            values_dict[file_names[counter]].append(A_count)
                            index_list.append('C count')
                            values_dict[file_names[counter]].append(C_count)
                            index_list.append('G count')
                            values_dict[file_names[counter]].append(G_count)
                            index_list.append('T count')
                            values_dict[file_names[counter]].append(T_count)
                        else:
                            values_dict[file_names[counter]].append(A_count)
                            values_dict[file_names[counter]].append(C_count)
                            values_dict[file_names[counter]].append(G_count)
                            values_dict[file_names[counter]].append(T_count)
                    else:
                        if h == 0 and i == 0:
                            index_list.append(header)
                            values_dict[file_names[counter]].append(value)
                        else: 
                            values_dict[file_names[counter]].append(value)
        
        counter += 1
                    
#create df
df = pd.DataFrame(dict([ (k,pd.Series(v)) for k,v in values_dict.items() ])).T
df.columns = index_list

#add columns and set index
df['Assembly'] = temp_assembly_names
df['Haplotype'] = temp_hap_names
df = df.set_index(['Assembly', 'Haplotype'])

df = df.T
df.to_csv(csv_name + '.csv') 

#create bargraph
row_list = map(int, df.loc['Scaffold N50'].values.flatten().tolist())
row_list = list(row_list)
temp_list = list(divide_chunks(row_list, 2))
index_list = list(df.columns.get_level_values(0))
df1 = pd.DataFrame(temp_list, index=index_list, columns=['Haplotype 1', 'Haplotype 2'])
df1 = df1.astype(float).reset_index()
bargraph(df, graph_name1)

