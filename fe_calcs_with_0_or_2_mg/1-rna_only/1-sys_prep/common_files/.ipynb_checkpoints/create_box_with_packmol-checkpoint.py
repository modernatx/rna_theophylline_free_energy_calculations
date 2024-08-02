
from openmoltools import packmol

molfiles_pdb = ['common_files-rna.pdb', 'common_files_sqm.pdb']
nmols = [1, 1]
boxsize = 100 # Angstroms

box = packmol.pack_box(molfiles_pdb, nmols, tolerance=10.0, box_size=boxsize)
box.save('box.pdb')

print("Packmol created simulation box!")
