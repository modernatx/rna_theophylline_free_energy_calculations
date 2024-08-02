import numpy as np
import os
import sys


rna_rmsd = np.loadtxt('rmsd_rna_150KCl_Mg.txt')

print('rna 150',np.mean(rna_rmsd[:,1]), np.std(rna_rmsd[:,1]))

rna_rmsd_55 = np.loadtxt('rmsd_rna_55NaCl_Mg.txt')

print('rna 55',np.mean(rna_rmsd_55[:,1]), np.std(rna_rmsd_55[:,1]))



lig_rmsd = np.loadtxt('rmsd_lig_150KCl_Mg.txt')

print('lig 150',np.mean(lig_rmsd[:,1]), np.std(lig_rmsd[:,1]))

lig_rmsd_55 = np.loadtxt('rmsd_lig_55NaCl_Mg.txt')

print('lig 55',np.mean(lig_rmsd_55[:,1]), np.std(lig_rmsd_55[:,1]))