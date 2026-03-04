#created by Sarah E. Fumagalli

import argparse
import pandas as pd

parser=argparse.ArgumentParser()

parser.add_argument("--gap_fixes", type=str, help='gap_fixes.txt path')
parser.add_argument("--initial_gaps", type=str, help='verkko_initial_gaps.csv path')

args = parser.parse_args()

df = pd.read_csv(args.initial_gaps, index_col=0).drop(['gaps', 'notes', 'fixedPath', 'startMatch', 'endMatch', 'finalGaf', 'done'], axis = 'columns')

gap_fixes = {}
count = 0
with open(args.gap_fixes, 'r') as file:
    for index, line in enumerate(file):
        if (index % 2) == 0:
            #even line - gap headers
            header = line.strip()
            header_list = header.split(';')
            print(header_list)
            print('count=',count)
            if len(header_list) > 1:
                #if more than one gap listed
                #go through list and find hapmer name in df
                hapmer_list = []
                for i in header_list:
                    if 'gap' in i:
                        hapmer_list.append(df.loc[i]['name'])
                    else:
                        hapmer_list.append(i)
                hapmer = ';'.join(hapmer_list)
                print('hapmer=',hapmer)
            else:
                #if only one gap listed
                if 'gap' in header_list[0]:
                    hapmer = df.loc[header_list[0]]['name']
                else:
                    hapmer = header_list[0]
                print(hapmer)

            count += len(header_list)
            
        else:
            #odd line - gap path
            line = line.replace(" ", "").strip()
            print('line=',line)
            if line == 'NA':
                print('skipping gapid')
                continue
            else:
                #convert symbols and remove commas
                converted = []
                if line.startswith('utig'):
                    #process paths starting with utig and contains -/+
                    print('line starts with utig')
                    for segment in line.split(','):
                        if segment.endswith('-'):
                            converted.append(f'<{segment[:-1]}')
                        elif segment.endswith('+'):
                            converted.append(f'>{segment[:-1]}')
                        else:
                            converted.append(segment)  # catch unexpected format
                    gap_fixes[hapmer] = ''.join(converted)
                else:
                    #process paths starting with < or >
                    print('line starts with > or <')
                    gap_fixes[hapmer] = line
                
final_df = pd.DataFrame.from_dict(gap_fixes, orient='index').reset_index()
final_df_path = args.initial_gaps.strip('verkko_initial_gaps.csv')
final_df.to_csv(final_df_path + 'converted_gap_fixes.tsv', sep="\t", header=False, index=False)

            
            
            
