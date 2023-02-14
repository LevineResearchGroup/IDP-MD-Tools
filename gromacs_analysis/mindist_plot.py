#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 14:15:59 2022

Plot mindist output from gromacs. Minimum distance over frame.
Just a plotter script.

@author: bab226
"""

import numpy as np
import gromacs.formats as gmx
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import random 
from matplotlib.ticker import FormatStrFormatter

def get_cmap(n, name='viridis'):
    '''Returns a function that maps each index in 0, 1, ..., n-1 to a distinct 
    RGB color; the keyword argument name must be a standard mpl colormap name.'''
    return plt.cm.get_cmap(name, n)

color = sns.color_palette('deep', 5, desat=1)

#Data Path:
path = "/Users/bab226/Documents/yale_research/iapp/md_sims/small_box/iapp_30mer/5_prod/"

#CSV-converted xvg files
width = 3.42
#eq_time = 100 # time for equilibration in ns

file1 = 'numcont.csv'
#file2 = 'r_15/mindist.csv'

df1 = pd.read_csv(path + file1, header=None, names=['time','mindist'])
df1 = df1.apply(pd.to_numeric, args=('coerce',))   #Make string into floats!

dist1 = df1['mindist'][1:len(df1):10]
frame = list(range(0,len(dist1)))

# df2 = pd.read_csv(path + file2, header=None, names=['time','mindist'])
# df2 = df2.apply(pd.to_numeric, args=('coerce',))   #Make string into floats!

# dist2 = df2['mindist'][1:]
# frame = list(range(0,len(dist2)))

fig, ax = plt.subplots(1, 1, figsize=(width,width/1.2))


ax.yaxis.set_major_formatter(FormatStrFormatter('%.1f'))

ax.scatter(frame, dist1, color=color[0], label='r11')

# ax.scatter(frame, dist2, color=color[1], label='r15')
ax.legend(loc='best')
ax.set_xlabel('Frame')
ax.set_ylabel('Dist (nm)')
#ax.set_ylim(0, 0.1)

plt.savefig(path + 'mindist_contacts.png', dpi=300, transparent=False, bbox_inches='tight')
