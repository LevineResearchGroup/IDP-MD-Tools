#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep 22 10:37:17 2022

DSSP Plotting Wrapper
by Bryan Bogin

1. Run DSSP analysis

echo 1 | gmx do_dssp -f traj_no_water.xtc -s topol_no_water_2019.tpr -n

2. Create new pdb for dssp perl script.

echo 1 | gmx trjconv -f ../start.gro -s ../topol.tpr -n -o dssp.pdb

3. Finally, run the perl script:

Perl analyze_ss.pl ../ss.xpm dssp.pdb

4. Prepare dssp_summary file by removing ## and @ lines.

grep -v '^##' dssp_summary.txt | grep -v '^@' > dssp_summary_edit.txt

5. Run this script :)
    
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
path = "/Users/bab226/Documents/yale_research/iapp/md_sims/iapp_adm116/new_files/analysis/dssp/"
path2 = "/Users/bab226/Documents/yale_research/iapp/md_sims/iapp_monomer/analysis/dssp/"

#CSV-converted xvg files
width = 3.42
#eq_time = 100 # time for equilibration in ns

file = 'dssp_summary_edit.txt'
df = pd.read_table(path+file, delimiter="\t")
col = df.columns
fig, ax = plt.subplots(1, 1, figsize=(width,width/2.3))

file2 = 'dssp_summary_edit.txt'
df2 = pd.read_table(path2+file2, delimiter="\t")
col2 = df2.columns

residue = df[col[0]]
idr = df[col[1]]
alpha = df[col[2]]
beta = df[col[3]]

residue2 = df2[col[0]]
idr2 = df2[col[1]]
alpha2 = df2[col[2]]
beta2 = df2[col[3]]

idr_diff = idr-idr2
alpha_diff = alpha - alpha2
beta_diff = beta - beta2



i = random.randint(0,4)
#ax.plot(residue, idr, color=color[0], label=i)
ax.plot(residue, alpha, color=color[1], label='a-helix')
ax.plot(residue, beta, color=color[2], label='beta-sheet')
ax.set_xlabel('Residue', labelpad=5)
ax.set_ylabel('Probability')
ax.set_ylim(0, 1)
ax.legend(loc="best", fontsize=6)
my_xticks = ['Lys1', 'Cys2', 'Asn3', 'Thr4', 'Ala5', 'Thr6', 'Cys7', 'Ala8', 'Thr9', 'Gln10', 'Arg11', 'Leu12', 'Ala13', 'Asn14', 'Phe15', 'Leu16', 'Val17', 'His18', 'Ser19', 'Ser20', 'Asn21', 'Asn22', 'Phe23', 'Gly24', 'Ala25', 'Ile26', 'Leu27', 'Ser28', 'Ser29', 'Thr30', 'Asn31', 'Val32', 'Gly33', 'Ser34', 'Asn35', 'Thr36', 'Tyr37']
plt.xticks(residue, my_xticks, rotation=90)
plt.rc('xtick', labelsize=5) 
plt.tick_params(axis='both', which='major', pad=2)
plt.savefig(path + 'dssp_iapp_adm.png', dpi=300, transparent=False, bbox_inches='tight')


fig2, ax = plt.subplots(1, 1, figsize=(width,width/2.3))

i = random.randint(0,4)
#ax.plot(residue, idr_diff, color=color[0], label=i)
ax.plot(residue, alpha2, color=color[1], label='a-helix')
ax.plot(residue, beta2, color=color[2], label='beta-sheet')
ax.set_xlabel('Residue', labelpad=5)
ax.set_ylabel('Probability')
ax.set_ylim(0, 1)
ax.legend(loc="best", fontsize=6)
my_xticks = ['Lys1', 'Cys2', 'Asn3', 'Thr4', 'Ala5', 'Thr6', 'Cys7', 'Ala8', 'Thr9', 'Gln10', 'Arg11', 'Leu12', 'Ala13', 'Asn14', 'Phe15', 'Leu16', 'Val17', 'His18', 'Ser19', 'Ser20', 'Asn21', 'Asn22', 'Phe23', 'Gly24', 'Ala25', 'Ile26', 'Leu27', 'Ser28', 'Ser29', 'Thr30', 'Asn31', 'Val32', 'Gly33', 'Ser34', 'Asn35', 'Thr36', 'Tyr37']
plt.xticks(residue, my_xticks, rotation=90)
plt.rc('xtick', labelsize=5) 
plt.tick_params(axis='both', which='major', pad=2)
plt.savefig(path2 + 'dssp_iapp.png', dpi=300, transparent=False, bbox_inches='tight')

fig3, ax = plt.subplots(1, 1, figsize=(width,width/2.3))

i = random.randint(0,4)
#ax.plot(residue, idr_diff, color=color[0], label=i)
ax.plot(residue, alpha_diff, color=color[1], label="a-helix")
ax.plot(residue, beta_diff, color=color[2], label="beta-sheet")
ax.set_xlabel('Residue', labelpad=5)
ax.set_ylabel('Probability')
ax.set_ylim(-0.3, 0.3)
ax.legend(loc="best", fontsize=6)
my_xticks = ['Lys1', 'Cys2', 'Asn3', 'Thr4', 'Ala5', 'Thr6', 'Cys7', 'Ala8', 'Thr9', 'Gln10', 'Arg11', 'Leu12', 'Ala13', 'Asn14', 'Phe15', 'Leu16', 'Val17', 'His18', 'Ser19', 'Ser20', 'Asn21', 'Asn22', 'Phe23', 'Gly24', 'Ala25', 'Ile26', 'Leu27', 'Ser28', 'Ser29', 'Thr30', 'Asn31', 'Val32', 'Gly33', 'Ser34', 'Asn35', 'Thr36', 'Tyr37']
plt.xticks(residue, my_xticks, rotation=90)
plt.rc('xtick', labelsize=5) 
plt.tick_params(axis='both', which='major', pad=2)
plt.savefig(path + 'dssp_diff.png', dpi=300, transparent=False, bbox_inches='tight')
