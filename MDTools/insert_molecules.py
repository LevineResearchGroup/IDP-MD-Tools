#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 13 12:36:02 2022

Printing script GROMACS commands to insert-molecules.

@author: bab226
"""

print("gmx insert-molecules -f sds2x.gro -ci iapp1.pdb -nmol 6 -try 1000 -o temp2.gro")
#print("gmx insert-molecules -f temp2.gro -ci adm1_ini.pdb -nmol 1 -try 10000 -o temp3.gro")
c = 2
for i in range(2, 11, 1):
    j=i+1
    print("gmx insert-molecules -f temp%s.gro -ci iapp%s.pdb -nmol 6 -try 10000 -o temp%s.gro" %(i,c,j))
    k=i+2
    #print("gmx insert-molecules -f temp%s.gro -ci adm1_ini.pdb -nmol 1 -try 10000 -o temp%s.gro" %(j,k))
    c = c + 1