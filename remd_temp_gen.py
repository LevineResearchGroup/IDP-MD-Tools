#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Oct  7 13:56:18 2022

@author: bab226
"""

# Code to format temperatures after using online generator. (See references below.)
import numpy as np
import pandas as pd
temp_dist = np.array([290.00, 291.86, 293.73, 295.61, 297.50, 299.40, 301.31, 303.23, 305.16, 307.10, 309.05, 311.02, 312.99, 314.97, 316.96, 318.97, 320.98, 323.01, 325.04, 327.09, 329.15, 331.21, 333.29, 335.38, 337.48, 339.59, 341.72, 343.85, 346.00, 348.15, 350.32, 352.50, 354.70, 356.91, 359.12, 361.35, 363.59, 365.84, 368.11, 370.38, 372.67, 374.97, 377.28, 379.60, 381.93, 384.28, 386.64, 389.02, 391.40, 393.80, 396.22, 398.64, 401.05, 403.50, 405.96, 408.43, 410.92, 413.43, 415.95, 418.48, 421.02, 423.58, 426.14, 428.73, 431.32, 433.93, 436.62, 439.26, 441.91, 444.58, 447.26, 449.96, 452.67, 455.39, 458.13, 460.88, 463.65, 466.44, 469.23, 472.05, 474.88, 477.74, 480.59, 483.46, 486.35, 489.26, 492.18, 495.11, 498.06, 500.00])
replicate = list(range(0,len(temp_dist)))
data_tuples = list(zip(replicate,temp_dist))
data = pd.DataFrame(data_tuples, columns=['Replicate', 'Temp'])
#np.savetxt('/storage/iapp/iapp_monomer/temperatures.txt', data.values, fmt='%d')
print(len(data))


