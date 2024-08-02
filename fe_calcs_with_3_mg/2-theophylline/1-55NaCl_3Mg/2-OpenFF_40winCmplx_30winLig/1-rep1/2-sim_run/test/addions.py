# import parmed as pmd

# # Load the prmtop and inpcrd files
# # prmtop = pmd.load_file('newfile.prmtop')
# # inpcrd = pmd.load_file('newfile.inpcrd')

# # Create a Modeller object from the topology
# modeller = pmd.modeller('newfile.prmtop', 'newfile.inpcrd')

# # Add ions to the system
# modeller.add_ions('Cl-', 21)

# # Get the modified system
# system = modeller.get_system()

# # Save the modified system as a new prmtop and inpcrd file
# system.save('system_with_ions.prmtop', overwrite=True)
# system.save('system_with_ions.inpcrd', overwrite=True)

import parmed as pmd

# Load the Amber prmtop and inpcrd files
prmtop = pmd.load_file('newfile.prmtop')
inpcrd = pmd.load_file('newfile.inpcrd', format='amber')

orig_structure = parmed.amber.AmberParm(in_prmtop, in_crd)

# Create a Cl- ion residue using the pre-defined ion templates in ParmEd
cl_residue = pmd.residue.LJIon.from_parameters('Cl-', 1, 'cl', mass=35.45)

# Add 10 Cl- ions to the system randomly
for i in range(10):
    cl = cl_residue.copy()
    cl.name = f'Cl{i+1}'
    cl.charge = -1
    prmtop.residues.append(cl)
    inpcrd.positions = pmd.geometry.box_vectors_to_unit_cells(inpcrd.box,
                                                               inpcrd.positions)
    inpcrd.positions = pmd.geometry.box_vectors_to_lengths_and_angles(inpcrd.box)[:3]
    inpcrd.positions.append([0, 0, 0])
    inpcrd.atoms.append(cl.atoms[0])

# Save the modified prmtop and inpcrd files
prmtop.write_parm('system_with_cl.prmtop')
inpcrd.write_parm('system_with_cl.inpcrd')