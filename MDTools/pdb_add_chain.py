#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 10 13:41:36 2023

#Prints sed commands to rename chains in PDB file.

@author: bab226
"""
import numpy as np
from string import ascii_uppercase
from string import ascii_lowercase
from random import choice

#Define protein 1 atom selections
num_protein = 30
num_atoms = 536
idx_start = 1
idx_end = idx_start + (num_atoms)
text1 = "a %d-%d" %(idx_start, idx_end)
idx_start_arr = []
idx_end_arr = []
idx_start_arr.append(idx_start)
idx_end_arr.append(idx_end)
#print(text1)
for i in range(1, num_protein+1):
    idx = i-1
    
    idx_start = idx_end + 2
    idx_end = idx_start + (num_atoms)
    idx_start_arr.append(idx_start)
    idx_end_arr.append(idx_end)
    text1 = "a %d-%d" %(idx_start, idx_end)
    #print(text1)
    
#String of uppercase
letters = []
for i in range(0,26):
    l = ascii_uppercase[i] + " "
    letters = np.append(letters, l)

#String of lowercase

for i in range(0,26):
    l = ascii_uppercase[i] 
    l = l + "2" 
    letters = np.append(letters, l)
    
for i in range(0,30):
    print("sed \'s/ A / %s /\' chainA.pdb > chain%s.pdb" %(letters[i], letters[i]))
    
for i in range(0,30):
    print("chain%s.pdb" %(letters[i]), end=" ")

print("sed '1,537 s/^\(ATOM.\{68\}\)  /\\1A /' final_protein.pdb > temp1.pdb")
for i in range(1,30):
    print("sed '%s,%s s/^\(ATOM.\{68\}\)  /\\1%s/' temp%s.pdb > temp%s.pdb" %(idx_start_arr[i], idx_end_arr[i], letters[i], i, i+1))