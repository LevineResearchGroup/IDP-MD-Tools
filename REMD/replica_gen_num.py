#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  7 13:58:53 2022

@author: bab226
"""

# Short code to print list of numbers for multidir mdrun step.
import numpy as np
import pandas as pd
list = []
for i in range(0,90):
    list.append(i)
    
print(*list)