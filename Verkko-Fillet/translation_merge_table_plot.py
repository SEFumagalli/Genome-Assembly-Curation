import os
import seaborn as sns
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap
import pandas as pd
import argparse

parser=argparse.ArgumentParser()

parser.add_argument("--verkkoDir", type=str, help='verkko directory pathway')
parser.add_argument("--phase_datatype", type=str, help='phase datatype')

args = parser.parse_args()



def contigPlot(translation_merged, datatype, ctgs, scfs, verkkoDir):
    """

    Creates heatmap capturing gaps, telomeres, contigs, and scaffolds for each chromosome
    Output: contigPlot.png

    """

    def chromo_double_check(chr_name, plt_dict, translation_merged, index):
        """

        If chromosome name is already found in dictionary, expand naming.

        """

        if 'haplotype1' in translation_merged.at[index, 'index']:
            if 'Haplotype 1' in plt_dict.keys():
                if chr_name in plt_dict['Haplotype 1'].keys():
                    chr_name = chr_name + "_" + translation_merged.at[index, 'index']
        if 'haplotype2' in translation_merged.at[index, 'index']:
            if 'Haplotype 2' in plt_dict.keys():
                if chr_name in plt_dict['Haplotype 2'].keys():
                    chr_name = chr_name + "_" + translation_merged.at[index, 'index']
        if 'sire' in translation_merged.at[index, 'index']:
            if 'Sire' in plt_dict.keys():
                if chr_name in plt_dict['Sire'].keys():
                    chr_name = chr_name + "_" + translation_merged.at[index, 'index']
        if 'dam' in translation_merged.at[index, 'index']:
            if 'Dam' in plt_dict.keys():
                if chr_name in plt_dict['Dam'].keys():
                    chr_name = chr_name + "_" + translation_merged.at[index, 'index']

        return chr_name


    def color_double_check(chr_name, color, plt_dict):
        """

        If color name is already found in dictionary with same chromosome, do not add new to dict.

        """

        if 'haplotype1' in chr_name:
            name_split = chr_name.split('_')
            if color == plt_dict['Haplotype 1'][name_split[0]]:
                chr_name = name_split[0]
        if 'haplotype2' in chr_name:
            name_split = chr_name.split('_')
            if color == plt_dict['Haplotype 2'][name_split[0]]:
                chr_name = name_split[0]
        if 'sire' in chr_name:
            name_split = chr_name.split('_')
            if color == plt_dict['Sire'][name_split[0]]:
                chr_name = name_split[0]
        if 'dam' in chr_name:
            name_split = chr_name.split('_')
            if color == plt_dict['Dam'][name_split[0]]:
                chr_name = name_split[0]

        return chr_name

    #change labels
    if datatype == 'hic':
        plt_dict = {'Haplotype 1':{}, 'Haplotype 2':{}}
    else:
        plt_dict = {'Sire':{}, 'Dam':{}}
    
    #format dictionary for plot
    for index, row in translation_merged.iterrows():
        #check for chromosome 
        if pd.isna(translation_merged.at[index, 'chr']):
            continue
        else:
            #format chromosome name
            name_split = row.iloc[1].split('_')
            chr_name = 'Chr' + name_split[len(name_split)-1]
            chr_name = chromo_double_check(chr_name, plt_dict, translation_merged, index)
            
            #check if ctgs and scfs dfs are empty
            if ctgs.shape[0] == 0:
                if scfs.shape[0] == 0:
                    #print('no ctgs or scfs files')
                    continue
                else:
                    #print('only scfs file')
                    if pd.isna(translation_merged.at[index, 'scfs']):
                        #check number of telomeres
                        if row['telomeres'] < 2 or pd.isna(translation_merged.at[index, 'telomeres']) == True:
                            color = 3
                    else:
                        #check for gaps
                        if pd.isna(translation_merged.at[index, 'gaps']):
                            continue
                        else:
                            color = 2
            else:
                if scfs.shape[0] == 0:
                    #print('only ctgs file')
                    continue
                else:
                    #print('both ctgs and scfs files')
                    if pd.isna(translation_merged.at[index, 'ctgs']):
                        #print('ctg not T2T')
                        #check for scaffold
                        if pd.isna(translation_merged.at[index, 'scfs']):
                            #print('scf not T2T')
                            #check number of telomeres
                            if row['telomeres'] < 2 or pd.isna(translation_merged.at[index, 'telomeres']) == True:
                                #print('1 telomere or NA')
                                color = 3
                        else:
                            #print('scf T2T')
                            #check for gaps
                            if pd.isna(translation_merged.at[index, 'gaps']):
                                continue
                            else:
                                #print('found gaps')
                                color = 2
                    else:
                        #print('ctg T2T')
                        #check for gaps
                        if pd.isna(translation_merged.at[index, 'gaps']):
                            #print('no gaps')
                            color = 1
           
            #check if chromosome is already listed, if so does it have the same color assigned. If matched, continue. Otherwise, add to dict.
            if len(chr_name) > 6:
                chr_name = color_double_check(chr_name, color, plt_dict)

            #add new information to dictionary
            if datatype != 'hic':
                if 'sire' in row.iloc[0]:
                    plt_dict['Sire'][chr_name] = color
                if 'haplotype1' in row.iloc[0]:
                    plt_dict['Sire'][chr_name] = color
                if 'dam' in row.iloc[0]:
                    plt_dict['Dam'][chr_name] = color
                if 'haplotype2' in row.iloc[0]:
                    plt_dict['Dam'][chr_name] = color
            else:
                if 'haplotype1' in row.iloc[0]:
                    plt_dict['Haplotype 1'][chr_name] = color
                if 'haplotype2' in row.iloc[0]:
                    plt_dict['Haplotype 2'][chr_name] = color

    #format file name
    split = verkkoDir.split('/')
    fig_name = split[-1]

    #create figure and save
    df = pd.DataFrame(plt_dict)
    fig, ax = plt.subplots(figsize=(8, 12))
    myColors = ((0.2, 0.7, 0.3, 0.5), (0.3, 0.3, 0.6, 0.6), (0.9, 0.6, 0.5, 0.9))
    cmap = LinearSegmentedColormap.from_list('Custom', myColors, len(myColors))
    ax = sns.heatmap(df, ax=ax, cmap=cmap,
                 linewidths=.5, linecolor='lightgray',
                 cbar_kws={'orientation': 'vertical', 'shrink': 0.5})
    colorbar = ax.collections[0].colorbar
    colorbar.set_ticks([1.35, 2, 2.6])
    colorbar.set_ticklabels(['contig\n(complete T2T w/o gaps)', 'scaffold\n(T2T w/ gaps or tangles)', 'not a scaffold\n(missing one of the telomere)'])
    ax.set_title(fig_name, fontdict={'size': 14})
    ax.set_ylabel('Chromosome')
    ax.set_xlabel('Haplotype')
    ax.set_yticklabels(ax.get_yticklabels(), rotation=0)
    plt.tight_layout()
    plt.savefig(verkkoDir + '/contigPlot.png', bbox_inches='tight')
    plt.close()


def merge(translation, ctgs, scfs, telo, gap):
    """
    
    Merges pandas df translation_hap1 and hap2, assembly.t2t_ctgs, assembly.t2t_scfs, and assembly.telomere.bed
    Output: translation_merged3
    
    """
    
    def format(translation_merged, telo, gap):
        telo_list = telo.index.tolist()
        telo_dict = {}
        for i in telo_list:
            if i in telo_dict.keys():
                telo_dict[i] += 1
            else:
                telo_dict[i] = 1
        telo_df = pd.DataFrame.from_dict(telo_dict, orient='index', columns=['telomeres'])
        translation_merged2 = pd.concat([translation_merged, telo_df], axis=1)

        gaps_list = gap.index.tolist()
        gaps_dict = {}
        for i in gaps_list:
            if i in gaps_dict.keys():
                gaps_dict[i] += 1
            else:
                gaps_dict[i] = 1
        gaps_df = pd.DataFrame.from_dict(gaps_dict, orient='index', columns=['gaps'])
        translation_merged2 = pd.concat([translation_merged2, gaps_df], axis=1)

        translation_merged2 = translation_merged2.reset_index()

        return translation_merged2
    
    #check if number of T2T ctgs equals 0
    if ctgs.shape[0] == 0:
        if scfs.shape[0] == 0:
            #print('no ctgs or scfs files')
            translation_merged2 = translation
        else:
            #print('only scfs file')
            scfs['scfs'] = 1
            translation_merged = pd.concat([translation, scfs], axis=1)
            translation_merged2 = format(translation_merged, telo, gap)
    else:
        ctgs['ctgs'] = 1
        if scfs.shape[0] == 0:
            #print('only ctgs file')
            translation_merged = pd.concat([translation, ctgs], axis=1)
            translation_merged2 = format(translation_merged, telo, gap)
        else:
            #print('both ctgs and scfs files')
            scfs['scfs'] = 1
            translation_merged = pd.concat([translation, ctgs, scfs], axis=1)
            translation_merged2 = format(translation_merged, telo, gap)

    translation_merged3 = translation_merged2.drop([2,3], axis=1)
    translation_merged3.rename(columns={1: 'chr'}, inplace=True)

    return translation_merged3


def duplicate_check(translation_hap1, translation_hap2):
    """

    Check translation files for duplicate haplotype names. 
    If a duplicate is found, an error will be flagged.
    Output: translation_hap1, translation_hap2, and contig_error

    """

    #check for duplications in each translation file
    hap1_duplicate = translation_hap1[translation_hap1.duplicated([0])]
    hap2_duplicate = translation_hap2[translation_hap2.duplicated([0])]
        
    #if duplications exist, update translation files
    if len(hap1_duplicate) > 0:
        print('Error: haplotype1 contig duplication - please see translation_hap1 file to correct error.')
        contig_error = True
   else:
        contig_error = False

    #if duplications exist, update translation files
    if len(hap2_duplicate) > 0:
        print('Error: haplotype2 contig duplication - please see translation_hap2 file to correct error.')
        contig_error = True
   else: 
        contig_error = False  
    translation_hap1 = translation_hap1.set_index(0)
    translation_hap2 = translation_hap2.set_index(0)
    
    return translation_hap1, translation_hap2, contig_error


def upload_files(verkkoDir):
    """
    
    Open all files needed. Check if ctgs and/or scfs tables are empty.
    Output: ctgs, scfs, translation_hap1, translation_hap2, telo, gap

    """
    print('finding files')
    if os.path.isfile(verkkoDir + "/assembly.t2t_ctgs"):
        if os.path.getsize(verkkoDir + "/assembly.t2t_ctgs") != 0:
            ctgs = pd.read_csv(verkkoDir + "/assembly.t2t_ctgs", sep='\t', header=None, index_col=0)
        else:
            print('ctgs file is empty')
            ctgs  = pd.DataFrame()
    else:
        print('ctgs file not found')

    if os.path.isfile(verkkoDir + "/assembly.t2t_scfs"):
        if os.path.getsize(verkkoDir + "/assembly.t2t_scfs") != 0:
            scfs = pd.read_csv(verkkoDir + "/assembly.t2t_scfs", sep='\t', header=None, index_col=0)
        else:
            print('scfs file is empty')
            scfs  = pd.DataFrame()
    else:
        print('scfs file not found')

    if os.path.isfile(verkkoDir + "/translation_hap1"):
        translation_hap1 = pd.read_csv(verkkoDir + "/translation_hap1", sep='\t', header=None)
    else:
        print('translation_hap1 file not found')

    if os.path.isfile(verkkoDir + "/translation_hap2"):
        translation_hap2 = pd.read_csv(verkkoDir + "/translation_hap2", sep='\t', header=None)
    else:
        print('translation_hap2 file not found')

    if os.path.isfile(verkkoDir + "/assembly.telomere.bed"):
        telo = pd.read_csv(verkkoDir + "/assembly.telomere.bed", sep='\t', header=None, index_col=0)
    else:
        print('telomere file not found')

    if os.path.isfile(verkkoDir + "/assembly.gaps.bed"):
        gap = pd.read_csv(verkkoDir + "/assembly.gaps.bed", sep='\t', header=None, index_col=0)
    else:
        print('gaps file not found')

    return ctgs, scfs, translation_hap1, translation_hap2, telo, gap



#Create translation_merge file and contigPlot
ctgs, scfs, translation_hap1, translation_hap2, telo, gap = upload_files(args.verkkoDir)

print('looking for duplicates')
translation_hap1, translation_hap2, contig_error = duplicate_check(translation_hap1, translation_hap2)

if contig_error:
    sys.exit("duplicate contig found in translation file - exiting")
else:
    translation = pd.concat([translation_hap1, translation_hap2], axis=0)

    print('merging files')
    translation_merged = merge(translation, ctgs, scfs, telo, gap)

    print('saving merged file')
    translation_merged.to_csv(args.verkkoDir + '/translation_merged.tsv', sep='\t', index=False)

    print('creating heatmap')
    contigPlot(translation_merged, args.phase_datatype, ctgs, scfs, args.verkkoDir)
