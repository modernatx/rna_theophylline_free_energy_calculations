import parmed as pmd

amber = pmd.load_file('box.prmtop', 'box.pdb')

# Save a CHARMM PSF and crd file
amber.save('box.psf')
