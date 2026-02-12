from PIL import Image
import argparse
import os
import pandas as pd 


parser=argparse.ArgumentParser()

parser.add_argument("--assemblies", nargs="*", default=[], help='list of verkko-fillet and/or assembly folders')
parser.add_argument("--main_dir", type=str, help='main directory pathway - folder with all assemblies')

args = parser.parse_args()


def get_concat_h_multi_resize(im_list, resample=Image.BICUBIC):
    min_height = min(im.height for im in im_list)
    im_list_resize = [im.resize((int(im.width * min_height / im.height), min_height),resample=resample)
                      for im in im_list]
    total_width = sum(im.width for im in im_list_resize)
    dst = Image.new('RGB', (total_width, min_height))
    pos_x = 0
    for im in im_list_resize:
        dst.paste(im, (pos_x, 0))
        pos_x += im.width
    return dst

def get_concat_v_multi_resize(im_list, resample=Image.BICUBIC):
    min_width = min(im.width for im in im_list)
    im_list_resize = [im.resize((min_width, int(im.height * min_width / im.width)),resample=resample)
                      for im in im_list]
    total_height = sum(im.height for im in im_list_resize)
    dst = Image.new('RGB', (min_width, total_height))
    pos_y = 0
    for im in im_list_resize:
        dst.paste(im, (0, pos_y))
        pos_y += im.height
    return dst



assemblies = args.assemblies
main_dir = args.main_dir

png_list = []
df_list = []
for file in assemblies:
    print(file)
    #concat png files
    if file.endswith('_verkko_fillet'):
        file += '/chromosome_assignment'
    if os.path.isfile(main_dir + file + '/contigPlot.png'):
        png_list.append(Image.open(main_dir + file + '/contigPlot.png'))
    else:
        print('File not found:' + file + " " + 'contigPlot')
   
    #concat df files
    if os.path.isfile(main_dir + file + '/translation_merged_summary.tsv'):
        df = pd.read_csv(main_dir + file + '/translation_merged_summary.tsv', sep='\t', header=0, index_col=0)
        if '_verkko_fillet' in file:
            df.index = df.index.map(lambda x: file[:-36] + "_" + x)
        else:
            df.index = df.index.map(lambda x: file + "_" + x)
        
        if 'length' in df.columns:
            df = df.drop(columns=['length', 'ref length'])
        print(df)
        df_list.append(df)
    else:
        print('File not found:' + file + " " + 'df table')

get_concat_h_multi_resize(png_list).save(main_dir + 'VF_contigPlot-merged.png')

merged_df = pd.concat(df_list, axis=0)
merged_df.to_csv(main_dir + "VF_summary.tsv", sep = "\t")



