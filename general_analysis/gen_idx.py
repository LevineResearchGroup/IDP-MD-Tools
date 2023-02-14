#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 17:18:11 2022

@author: bab226
"""
import numpy as np
import gromacs.formats as gmx
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import random 

#Define protein 1 atom selections
num_protein = 30     #FIXME
num_atoms = 537
idx_start = 2604
#idx_start = 1
idx_end = idx_start + (num_atoms-1)
text1 = "a %d-%d" %(idx_start, idx_end)
idx_start_arr = []
idx_end_arr = []
idx_start_arr.append(idx_start)
idx_end_arr.append(idx_end)
#print(text1)
for i in range(1, num_protein+1):
    idx = i-1
    
    idx_start = idx_end + 1
    idx_end = idx_start + (num_atoms - 1)
    idx_start_arr.append(idx_start)
    idx_end_arr.append(idx_end)
    text1 = "a %d-%d" %(idx_start, idx_end)
    #print(text1)
    
protein = list(range(0, num_protein+1))
data1 = {'protein': protein,
        'start': idx_start_arr,
        'end': idx_end_arr}
df = pd.DataFrame(data1)
    
# #Define protein 2 atom selections    #FIXME
#idx2_start = 2604
idx2_start = 0
idx2_end = idx2_start + (num_atoms-1)
text2 = "a %d-%d" %(idx_start, idx_end)
idx2_start_arr = []
idx2_end_arr = []
idx2_start_arr.append(idx2_start)
idx2_end_arr.append(idx2_end)
#print(text1)
for i in range(1, num_protein+1):
    idx = i-1
    
    idx2_start = idx2_end + 1
    idx2_end = idx2_start + (num_atoms - 1)
    idx2_start_arr.append(idx2_start)
    idx2_end_arr.append(idx2_end)
    text1 = "a %d-%d" %(idx2_start, idx2_end)
    #print(text1)
# print("""
# mol modstyle 0 0 NewCartoon 0.300000 10.000000 4.100000 0
# mol modcolor 0 0 Structure"""
# )
# for i in range(0, num_protein+1):
#     print("""mol color ColorID %s
# mol representation NewCartoon 0.300000 10.000000 4.100000 0
# mol selection index %s to %s
# mol material MetallicPastel
# mol addrep 0
# mol modselect 6 0 index %s to %s
# """ %(i, idx_start_arr[i], idx_end_arr[i], idx_start_arr[i], idx_end_arr[i])
#     )
    
    print("""
a %s-%s
name %s iapp%s"""
%(idx_start_arr[i-1], idx_end_arr[i-1], i+13, i))