import pandas as pd
import argparse 
import os
import numpy as np
from pandas.errors import EmptyDataError
from collections import OrderedDict

pd.set_option('display.max_columns', None)  # or 1000
pd.set_option('display.max_rows', None)  # or 1000

parser=argparse.ArgumentParser()

parser.add_argument("--mashmap", nargs="*", default=[])
parser.add_argument("--translation", nargs="*", default=[])
parser.add_argument("--num_chromosomes", help='number of chromosomes input')

args = parser.parse_args()




#Input mashmap and translation file
trans_files = args.translation
num_chromos = int(args.num_chromosomes) #excluding sex chromosomes
mashmap_files = args.mashmap

#If using trio data with overlay Hi-C, split mashmap_files into dam/sire and hap1/hap2
if len(mashmap_files) > 2:
    print('split mashmap file list for trio/hi-c data')
    trio_hic = True
    split_point = len(mashmap_files) // 2
    mashmap_files1 = mashmap_files[:split_point]
    mashmap_files2 = mashmap_files[split_point:]
else:
    print('no trio/hi-c data')
    trio_hic = False



def missing_chromos(translation, num_chromos):
    """
    
    Finding missing from expected chromosomes.
    Output: needed_chromos
    
    """
    
    #set current chromosomes to list
    if translation.empty:
        print('Translation df is empty')
        current_chromos = []
    else:
        current_chromos = translation.iloc[:,1].tolist()

    #Iterate through the expected chromosomes and compare to translation file
    needed_chromos = []
    for j in range(1,num_chromos+1):
        if j < num_chromos-1:
            name = 'chr_' + str(j)
        elif j == num_chromos-1:
            name = 'chr_X'
        elif j == num_chromos:
            name = 'chr_Y'

        if any(filter(lambda x: name in x, current_chromos)):
            continue
        else: 
            if j < num_chromos-1:
                print('chromosome needed:=', j)
                needed_chromos.append(j)
            elif j == num_chromos-1:
                print('chromosome needed:=', 'X')
                needed_chromos.append('X')
            elif j == num_chromos:
                print('chromosome needed:=', 'Y')
                needed_chromos.append('Y')
        
    #check numbers 
    count = len(needed_chromos) + len(current_chromos)
    if count == num_chromos:
        print('chromosome numbers equal to expectation')
        print('number of needed chromosomes:=', len(needed_chromos))
        print('number of current chromosomes:=', len(current_chromos))
    else:
        print('chromosome numbers not adding up to expectation')
        print('count of needed and current=', count)
        print('number of needed chromosomes:=', len(needed_chromos))
        print('number of current chromosomes:=', len(current_chromos))


    return needed_chromos


        
def add_chromos(mashmap, num_chromos, translation):
    '''
    
    Finds missing chromosomes in mashmap and adds to translation file.
    Output: translation

    '''
         
    def chromo_to_translation(df, translation):
        '''

        Appends necessary information from mashmap to translation file.
        Output: translation

        '''
        
        print('adding contig to translation')
        addition = df.values.tolist()[0]

        if translation.empty:
            print('Filling empty translation df')
            translation = pd.DataFrame([[addition[0], addition[5], addition[1], addition[6]]]) 
        else:        
            translation.loc[len(translation)] = [addition[0], addition[5], addition[1], addition[6]]

        return translation
    

    
    def sex_chr_check(j, i, unique_contigs, mashmap_sub, translation, current_haps, contig_exists):
        """
        
        Check sex chromosome for length and PAR

        """
        print('unique_contigs=',unique_contigs) 
        #if more than one contig, check lengths and for PAR
        if len(unique_contigs) > 1:
            print('more than one contig')
            temp_df = mashmap_sub.copy()
            print('temp_mashmap=',temp_df)
            temp_df = temp_df[temp_df.iloc[:,0].apply(lambda x:i in x)]

            if 'X' in j:
                #check if any contigs are longer than 1000000 and start before 6000000 (PAR)
                if (temp_df[10] >= 1000000).any():          #and (temp_df[10] > temp_df[10] - 6000000).any():
                    print('X contig greater than 1mb and not PAR')
                    if contig_exists:
                        print('contig exists')
                    else:
                        translation = chromo_to_translation(temp_df, translation)
                        current_haps.append(i)
                    reorder_df = False
                else:
                    print('X contig less than 1mb - ignoring or PAR')
                    if contig_exists:
                        print('dropping PAR related chromosome')
                        translation.drop(translation[translation[1].str.contains(j)].index, inplace=True)
                    reorder_df = False

            if 'Y' in j:
                #check if any contigs are longer than 1000000 and start after 7000000 (PAR)
                if (temp_df[10] >= 1000000).any() and (temp_df[7] > 7000000).any():
                        print('Y contig greater than 1mb and not PAR')
                        if contig_exists:
                            print('contig exists')
                        else:
                            translation = chromo_to_translation(temp_df, translation)
                            current_haps.append(i)
                        reorder_df = True
                else:
                    print('Y contig less than 1mb - ignoring or PAR')
                    if contig_exists:
                        print('dropping PAR related chromosome')
                        translation.drop(translation[translation[1].str.contains(j)].index, inplace=True)
                    reorder_df = True
        else:
            print('only one contig')    
            if (mashmap_sub[10] >= 1000000).any():
                print('contig greater than 1mb')
                if contig_exists:
                    print('contig exists')
                    #check to see if chromosome exists
                    if translation[1].str.contains(j).any():
                        print('contig really does exist')
                    else:
                        #add chromosome
                        translation = chromo_to_translation(mashmap_sub, translation)
                        current_haps.append(i)
                else:
                    print('add contig')
                    translation = chromo_to_translation(mashmap_sub, translation)
                    current_haps.append(i)
                if 'Y' in j:
                    reorder_df = True
                else:
                    reorder_df = False
            else:
                print('contig less than 1mb - ignoring')
                if contig_exists:
                    print('dropping PAR related contig')
                    translation.drop(translation[translation[1].str.contains(j)].index, inplace=True)
                if 'Y' in j:
                    reorder_df = True
                else:
                    reorder_df = False


        return translation, reorder_df



    #create expected chromosome list for reference
    chromo_list = list(range(1,num_chromos-1)) + ['X', 'Y']
    chromo_list = ['chr_' + str(s) for s in chromo_list]
    
    #check if translation df is empty, if not grab first column
    if translation.empty:
        current_haps = []
    else:
        current_haps = translation.iloc[:,0].tolist()
 
    #iterate through expected chromosome list
    for index, j in enumerate(chromo_list):
        print('chromo=',j)
        #filter mashmap for chromosome
        mashmap_sub = mashmap_copy[mashmap_copy.iloc[:,5].apply(lambda x:j in x)] 
        if mashmap_sub.empty:
            print('chromosome not found in mashmap')
            if j == 'chr_Y':
                reorder_df = True
            continue

        #sort by alignment length
        mashmap_sub = mashmap_sub.sort_values(by=[10], ascending=False)

        #identify unique contigs listed in mashimap_sub
        unique_contigs = mashmap_sub[0].unique() 

        #for each contig, filter df and check alignment length. if > 1mb contig gets added to translation df
        for i in unique_contigs:
            #print('unique contig=',i)
            if i in current_haps:
                print('chromosome already exists in translation file')
                #this may be incorrect if there is a duplicate contig name (happens more often for sex chromosomes)
                contig_exists = True
                #double check verkko-fillet's decision 
                if j == 'chr_X' or j == 'chr_Y':
                    print('double checking sex chromosomes')
                    translation, reorder_df = sex_chr_check(j, i, unique_contigs, mashmap_temp, translation, current_haps, contig_exists)
                if j == 'chr_Y':
                    reorder_df = True
                    break
            else:
                #check sex chromosomes 
                contig_exists = False
                if 'X' in j or 'Y' in j:
                    print('X or Y contig')
                    translation, reorder_df = sex_chr_check(j, i, unique_contigs, mashmap_temp, translation, current_haps, contig_exists)             
               else:
                    #check non-sex chromosomes
                    if len(unique_contigs) > 1:
                        print('more than one contig')
                        temp_df = mashmap_sub.copy()
                        temp_df = mashmap_sub[mashmap_sub.iloc[:,0].apply(lambda x:i in x)]
                        #check if any contigs are longer than 1000000
                        if (temp_df[10] >= 1000000).any():
                            print('contig greater than 1mb')
                            translation = chromo_to_translation(temp_df, translation)
                            current_haps.append(i)
                        else:
                            print('contig less than 1mb - ignoring')
                            if 'Y' in j: 
                                reorder_df = True
                    else:
                        print('only one contig')
                        translation = chromo_to_translation(mashmap_sub, translation)
                        current_haps.append(i)
            

    return translation, condition





def reorder(translation, num_chromos):
    """

    Reorder translation file by contig names
    Output: ordered_df
    
    """
    
    #create expected list of chromosomes
    num_list = list(range(1, num_chromos-1))
    num_list = list(map(str, num_list))
    chromo_names = [a + b for a, b in zip(['chr_']*num_chromos, num_list)]
    chromo_names += ['chr_X', 'chr_Y']

    #create and ordered dictionary by chromosome name
    ordered_dict = OrderedDict()
    counter = 0
    for i in chromo_names:
        #check sex chromosomes
        if i.endswith('X') or i.endswith('Y'):
            for index, row in translation.iterrows():
                split1 = row[1].split('_')
                if i.endswith(split1[len(split1)-1]):
                    ordered_dict[counter] = row.to_dict()
                    counter += 1
        else:
            #check non-sex chromosomes
            split1 = i.split('_')
            for index, row in translation.iterrows():
                split2 = row[1].split('_')
                if split1[1] == split2[len(split2)-1]:
                    ordered_dict[counter] = row.to_dict()
                    counter += 1
    
    ordered_df = pd.DataFrame.from_dict(ordered_dict, orient='index')
    ordered_df = ordered_df.reset_index(drop=True)
    if 'index' in ordered_df.columns:
        ordered_df = ordered_df.rename(columns={'index': 1})
    ordered_df = ordered_df.reindex(columns=[0,1,2,3])
    print(ordered_df)

    return ordered_df



def find_sex_chromos(mashmap, translation_hap1, translation_hap2):
    """
    
    If using sire/dam, look at haplotype contigs for sex chromosomes
    Output: translation_hap1, translation_hap2

    """

    #find sex chromosomes in mashmap
    chr_X = mashmap[mashmap[5].str.contains('chr_X')].sort_values(by=10, ascending=False)
    chr_Y = mashmap[mashmap[5].str.contains('chr_Y')].sort_values(by=10, ascending=False)

    #check if X chromosome exists
    if len(translation_hap1[translation_hap1[1].str.contains('chr_X')]) > 0 or len(translation_hap2[translation_hap2[1].str.contains('chr_X')]) > 0:
        print('chromosome X already exists in translation files')
    else:
        #check if any contigs are longer than 1000000 and less than 6000000
        if (chr_X[10] >= 1000000).any(): # and (chr_X[10] > chr_X[10] - 6000000).any():
            print('X contig greater than 1mb and not PAR')
            addition = chr_X.values.tolist()[0]
            if 'haplotype1' in addition[0]:
                print('chr_X added to dam')
                translation_hap1.loc[len(translation_hap1)] = [addition[0], addition[5], addition[1], addition[6]]
            else:
                print('chr_X added to sire')
                translation_hap2.loc[len(translation_hap2)] = [addition[0], addition[5], addition[1], addition[6]]
        else:
            print('X contig less than 1mb - ignoring or PAR')

    #check if Y chromosome exists
    if len(translation_hap1[translation_hap1[1].str.contains('chr_Y')]) > 0 or len(translation_hap2[translation_hap2[1].str.contains('chr_Y')]) > 0:
        print('chromosome Y already exists in translation files')
    else:
        #check if any contigs are longer than 1000000 and greater than 7000000
        if (chr_Y[10] >= 1000000).any() and (chr_Y[7] > 7000000).any():
            print('Y contig greater than 1mb and not PAR')
            addition = chr_Y.values.tolist()[0]
            print('added chr_Y to sire')
            translation_hap2.loc[len(translation_hap2)] = [addition[0], addition[5], addition[1], addition[6]]
        else:
            print('Y contig less than 1mb - ignoring or PAR')


    return translation_hap1, translation_hap2


#initial 'reorder_df' is set to false -- df will not be reordered
reorder_df = False

#iterate through each translation file
for j,i in enumerate(trans_files):
    print(i)
    #check if translation file is empty
    file_size = os.path.getsize(i)
    if file_size > 0:
        translation = pd.read_csv(i, sep='\t', header=None)
    else:
        translation = pd.DataFrame()
    print('trans=',translation) 

    #if phasing data is trio and hic, mashmap has been previously filtered
    if trio_hic:
        try:
            mashmap = pd.read_csv(mashmap_files1[j], sep='\t', header=None)
        except EmptyDataError:
            print("Mashmap haplotype file is empty. May need to # out mashmap_hap1 and mashmap_hap2 lines of code in sh file")
    else:
        try:
            mashmap = pd.read_csv(mashmap_files[j], sep='\t', header=None)
        except EmptyDataError:
            print("Mashmap file is empty. May have the wrong set of mashmap files # out in sh file")
            
    #check if mashmap is empty
    if mashmap.empty:
        print('Haplotype1/2 or dam/sire needs to be chosen in sh file')
        break
    else:
        print('find missing chromosomes')
        needed_chromos = missing_chromos(translation, num_chromos)
    
        print('add new chromosomes to translation file')
        mashmap_sub = mashmap.copy()
        translation, reorder_df = add_chromos(mashmap_sub, num_chromos, translation)
        if reorder_df: 
            translation = reorder(translation, num_chromos)       
                              
        #check for duplicate contigs
        duplicate_contigs = translation[translation.duplicated([0])]
        if len(duplicate_contigs) > 0:
            print('warning: duplicate contig names')
            print('duplicate_contigs=',duplicate_contigs)
            translation = reorder(translation, num_chromos)

            #check duplicates for sex chromosomes   
            if duplicate_contigs[1].str.contains('_chr_X').any() or duplicate_contigs[1].str.contains('_chr_Y').any():
                if j == 0:
                    print('hap1 sex chr duplicates found')
                    hap1_dups = duplicate_contigs[duplicate_contigs[1].str.contains('|'.join(['_chr_X', '_chr_Y']))]
                else:
                    print('hap2 sex chr duplicates found')
                    hap2_dups = duplicate_contigs[duplicate_contigs[1].str.contains('|'.join(['_chr_X', '_chr_Y']))]
            else:
                if j == 0:
                    hap1_dups = pd.DataFrame()
                else:
                    hap2_dups = pd.DataFrame()
                
        if j == 0:
            hap1_dups = pd.DataFrame()
            translation_hap1 = translation
        else:
            hap2_dups = pd.DataFrame()
            translation_hap2 = translation
            
    
if trio_hic:
    print('check haplotype files for missing chromosomes')
    mashmap1 = pd.read_csv(mashmap_files2[0], sep='\t', header=None)
    mashmap2 = pd.read_csv(mashmap_files2[1], sep='\t', header=None)
    mashmap = pd.concat([mashmap1, mashmap2], axis=0)
       
    translation_hap1, translation_hap2 = find_sex_chromos(mashmap, translation_hap1, translation_hap2)
    


def remove_sex_duplicates(df, dam_sire):
    """

    Removes X for sire and Y for dam

    """
    
    if dam_sire:
        #check sire df for X chr
        if df[1].str.contains('_chr_X').any() and df[0].str.contains('sire').any():
            print('drop chr X from sire')
            df.drop(df[df[1].str.contains('_chr_X')].index, inplace=True)

        #check dam df for Y chr
        if df[1].str.contains('_chr_Y').any() and df[0].str.contains('dam').any():
            print('drop chr Y from dam')
            df.drop(df[df[1].str.contains('_chr_Y')].index, inplace=True)
    else:
        #check haplotype df for X
        print('drop chr X from haplotype')
        df.drop(df[df[1].str.contains('_chr_X')].index, inplace=True)

    return df




print('checking sex chromosome duplicates')
if translation_hap2[0].str.contains('sire').any() and translation_hap1[0].str.contains('dam').any():
    print('dam and sire')
    dam_sire = True
    if len(hap1_dups) > 0:
        print('hap1 duplicates=', hap1_dups)
        translation_hap1 = remove_sex_duplicates(translation_hap1, dam_sire)
    if len(hap2_dups) > 0:
        print('hap2 duplicates=', hap2_dups)
        translation_hap2 = remove_sex_duplicates(translation_hap2, dam_sire)
else:
    print('hap1 and hap2')
    dam_sire = False
    #check for chr Y
    if translation_hap1[1].str.contains('_chr_Y').any():
        print('hap1 contains chr Y')
        translation_hap1 = remove_sex_duplicates(translation_hap1, dam_sire)
    if translation_hap2[1].str.contains('_chr_Y').any():
        print('hap2 contains chr Y')
        translation_hap2 = remove_sex_duplicates(translation_hap2, dam_sire)


translation_hap1.to_csv('translation_hap1.csv', sep="\t", header=False, index=False)
translation_hap2.to_csv('translation_hap2.csv', sep="\t", header=False, index=False)



