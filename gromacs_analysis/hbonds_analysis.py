#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 11:38:35 2022

Gromacs Hbond Analysis

@author: bab226
"""

import numpy as np
import gromacs.formats as gmx
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

def get_cmap(n, name='viridis'):
    '''Returns a function that maps each index in 0, 1, ..., n-1 to a distinct 
    RGB color; the keyword argument name must be a standard mpl colormap name.'''
    return plt.cm.get_cmap(name, n)

color = sns.color_palette('deep', 5, desat=1)

#Data Path:
path = "/Users/bab226/Documents/yale_research/iapp/md_sims/iapp_monomer/analysis/hbonds/"

#CSV-converted xvg files
width = 3.42
eq_time = 100 # time for equilibration in ns
for i in range(1, 5):
    file = 'hbnum_%s.csv' %(i)
    df = pd.read_csv(path + file)
    col = df.columns
    fig, ax = plt.subplots(1, 1, figsize=(width,width/1.2))
    time = df[col[0]]/1000 - eq_time
    hbonds = df[col[1]]
    
    ax.plot(time, hbonds, color=color[i], label=i)
    ax.set_xlabel('time (ns)')
    ax.set_ylabel('h-bonds')
    ax.set_ylim(0, 12.5)
    
    
