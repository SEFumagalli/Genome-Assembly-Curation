## ---------------------------------------------------------------------
## https://note.nkmk.me/en/python-pillow-concat-images/
## This file quickly joins several png file for easy comparison.
##
## Requirement: Must have previously ran Verkko-fillet or
##              chromo_assesement.sh.
##
## Input: configPlot.png for each assembly
##
## Output: contigPlot_merged.png
## ---------------------------------------------------------------------


from PIL import Image
import argparse
import os

parser=argparse.ArgumentParser()

parser.add_argument("--png_files", nargs="*", default=[], help='list of png files to concatenate')
parser.add_argument("--final_png", type=str, help='final png pathway')

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



files = args.png_files

file_list = []
for file in files:
    if os.path.isfile(file):
        file_list.append(Image.open(file))
    else:
        print('File not found:' + file)


get_concat_h_multi_resize(file_list).save(args.final_png)

