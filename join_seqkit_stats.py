## -----------------------------------------------------------------------
## This script collects each assembly's haplotype stats and combines
## them in a single csv.
## 
## Input for each assembly: haplotype1_stats.txt
##                          haplotype2_stats.txt
##
## Easily add or subtract the number of assemblies by adding or removing the number of lists
## and filenames (sh file), and arguments and file list (py file).
##          
## Output: seqkit_stats.csv
##         seqkit_stats_barplot.png
## -----------------------------------------------------------------------

import pandas as pd
import argparse 
import matplotlib.pyplot as plt
import seaborn as sns

pd.set_option('display.max_columns', None)  # or 1000
pd.set_option('display.max_rows', None)  # or 1000

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
parser.add_argument("--filenames", nargs="*", default=[])
parser.add_argument("--csvname", help='csv file name')
parser.add_argument("--graphname", help='bar graph file name')


args = parser.parse_args()

#Input mashmap and translation file

files = [args.lista, args.listb, args.listc, args.listd, args.liste, args.listf, args.listg, args.listh, args.listi,
        args.listj, args.listk, args.listl, args.listm, args.listn, args.listo, args.listp, args.listq, args.listr, args.lists]
filenames = args.filenames
csv_name = args.csvname
graph_name = args.graphname


def bargraph(bargraph_df1, bargraph_df2, bargraph_df3, bargraph_df4, bargraph_df5, bargraph_df6, graph_name):
    """
    
    Creates bargraph depitcting haplotype specific N50, number of seqeuences, and sum length for each assembly 

    """
    
    fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(10,10), gridspec_kw={'wspace':0.16, 'hspace':0.1, 'left':0.23})

    bargraph_df1.plot(ax=axes[0,0], kind='barh', sharex=True, sharey=False, legend=False, width=0.7)
    axes[0,0].invert_yaxis()
    bargraph_df2.plot(ax=axes[0,1], kind='barh', title = 'Gyr Assembly Haplotype Statistics', sharex=True, sharey=True, legend=False, width=0.7)
    axes[0,1].invert_yaxis()
    bargraph_df3.plot(ax=axes[0,2], kind='barh', sharex=True, sharey=True, legend=False, width=0.7)
    axes[0,2].invert_yaxis()
    bargraph_df4.plot(ax=axes[1,0], kind='barh', sharex=False, sharey=False, legend=False, width=0.7)
    axes[1,0].invert_yaxis()
    bargraph_df5.plot(ax=axes[1,1], kind='barh', sharex=False, sharey=True, legend=False, width=0.7)
    axes[1,1].invert_yaxis()
    bargraph_df6.plot(ax=axes[1,2], kind='barh', sharex=False, sharey=True, legend=False, width=0.7)
    axes[1,2].invert_yaxis()
    fig.supylabel('Assembly Haplotype')
    axes[1,0].set_xlabel('N50')
    axes[1,1].set_xlabel('Number of Sequences')
    axes[1,2].set_xlabel('Sum Length')
    axes[0,0].set_ylabel(' ')
    axes[0,1].set_ylabel(' ')
    axes[0,2].set_ylabel(' ')
    axes[1,0].set_ylabel(' ')
    axes[1,1].set_ylabel(' ')
    axes[1,2].set_ylabel(' ')
    plt.savefig(graph_name + '.png', bbox_inches='tight', dpi=300)
    plt.show()
    plt.close()



#iterate through files, set format, and save
df_list = []
counter = 0
for h,j in enumerate(files):
    print(j)
    for j,i in enumerate(j):    
        temp_df = pd.read_csv(i, sep="\t")
        temp_df['Assembly Haplotype'] = filenames[counter]
        df_list.append(temp_df)
        counter += 1
df_result = pd.concat(df_list, axis=0)
df_result = df_result.drop(['file','format','type', 'sum_gap', 'Q20(%)', 'Q30(%)'], axis=1)
first_column = df_result.pop('Assembly Haplotype') 
df_result.insert(0, 'Assembly Haplotype', first_column) 
df_result.set_index('Assembly Haplotype', inplace=True)
df_result.to_csv(csv_name + '.csv', index=True, header=True) 


print('creating bar graph')
#filter df_result for haplotype specific data
hap1_df = df_result.filter(like='Hap1', axis=0).reset_index()
hap2_df = df_result.filter(like='Hap2', axis=0).reset_index()

#split dfs by haplotype and data type (columns to display can be easily changed here)
bargraph_df1 = hap1_df[['Assembly Haplotype','N50']].set_index(['Assembly Haplotype'])
bargraph_df2 = hap1_df[['Assembly Haplotype','num_seqs']].set_index(['Assembly Haplotype'])
bargraph_df3 = hap1_df[['Assembly Haplotype','sum_len']].set_index(['Assembly Haplotype'])
bargraph_df4 = hap2_df[['Assembly Haplotype','N50']].set_index(['Assembly Haplotype'])
bargraph_df5 = hap2_df[['Assembly Haplotype','num_seqs']].set_index(['Assembly Haplotype'])
bargraph_df6 = hap2_df[['Assembly Haplotype','sum_len']].set_index(['Assembly Haplotype'])

#create bargraph
bargraph(bargraph_df1, bargraph_df2, bargraph_df3, bargraph_df4, bargraph_df5, bargraph_df6, graph_name)

