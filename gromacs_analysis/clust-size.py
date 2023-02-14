#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 20 17:33:28 2022

@author: bab226
"""

import numpy as np
import gromacs.formats as gmx
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import random 

def get_cmap(n, name='viridis'):
    '''Returns a function that maps each index in 0, 1, ..., n-1 to a distinct 
    RGB color; the keyword argument name must be a standard mpl colormap name.'''
    return plt.cm.get_cmap(name, n)

color = sns.color_palette('deep', 5, desat=1)

#Data Path:
path = "/Users/bab226/Documents/yale_research/iapp/md_sims/remd_iapp/iapp_adm116/new_files/analysis/cluster/cluster_helix/"

#CSV-converted xvg files
width = 3.42
#eq_time = 100 # time for equilibration in ns

file = 'clust-size.csv'
df = pd.read_csv(path + file, header=None, names=['cluster','frames'])
col = df.columns
fig, ax = plt.subplots(1, 1, figsize=(width,width/1.2))

total_frames = np.sum(df[col[1]])
cluster = df[col[0]]
prob = df[col[1]]/total_frames

i = random.randint(0,4)
ax.plot(cluster, prob, color=color[0], label=i)
ax.set_xlabel('Cluster')
ax.set_ylabel('Probability')
ax.set_ylim(0, 0.1)

plt.savefig(path + 'clust-size.png', dpi=300, transparent=False, bbox_inches='tight')
