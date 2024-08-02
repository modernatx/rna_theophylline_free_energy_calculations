import argparse

argParser = argparse.ArgumentParser()
argParser.add_argument("-s", "--sdf", help="small molecule sdf file")

args = argParser.parse_args()

# Read AMBER to ParmEd Structure object
import parmed

in_prmtop = "box_gaff.prmtop"
in_crd = "box_gaff.inpcrd"
orig_structure = parmed.amber.AmberParm(in_prmtop, in_crd)

pieces = orig_structure.split()
for piece in pieces:
    print(f"There are {len(piece[1])} instance(s) of {piece[0]}")




try:
    from openmm.app import PDBFile
except ImportError:
    from simtk.openmm.app import PDBFile

from openff.toolkit.topology import Molecule, Topology

ligand_off_molecule = Molecule(args.sdf)

ligand_off_topology = ligand_off_molecule.to_topology()





# Load the SMIRNOFF-format Sage force field
from openff.toolkit.typing.engines.smirnoff import ForceField

force_field = ForceField("openff_unconstrained-2.0.0.offxml")

ligand_system = force_field.create_openmm_system(ligand_off_topology)
new_ligand_structure = parmed.openmm.load_topology(
    ligand_off_topology.to_openmm(),
    ligand_system,
    xyz=pieces[1][0].positions,
)


new_ligand_structure.save("tmp.prmtop", overwrite=True)
new_ligand_structure.save("tmp.inpcrd", overwrite=True)


# Check how many atoms and which order elements are in the new ligand
n_atoms_new = len(new_ligand_structure.atoms)
elements_new = [atom.element for atom in new_ligand_structure.atoms]

# Check how many atoms and which order elements are in the old ligand
old_ligand_structure, n_copies = pieces[1]
n_atoms_old = len(old_ligand_structure.atoms)
elements_old = [atom.element for atom in old_ligand_structure.atoms]

print(
    f"There are {n_atoms_old} in the old ligand structure and {n_atoms_new} atoms "
    f"in the new ligand structure"
)

# Print out error message if number of atoms doesn't match
if n_atoms_new != n_atoms_old:
    print(
        "Error: Number of atoms in input ligand doesn't match number extracted "
        "from prmtop file."
    )

if elements_new != elements_old:
    print(
        "Error: Elements in input ligand don't match elements in the ligand "
        "from the prmtop file."
    )
    print(f"Old elements: {elements_old}")
    print(f"New elements: {elements_new}")





# Create a new, empty system
complex_structure = parmed.Structure()

# Add the protein. Convert explicitly to an AmberParm object to ensure that 1-4 scaling factors are preserved.
complex_structure += parmed.amber.AmberParm.from_structure(pieces[0][0])

print("BEFORE SYSTEM COMBINATION (just RNA)")
print(
    "Unique atom names:",
    sorted(list({atom.atom_type.name for atom in complex_structure})),
)
print(
    "Number of unique atom types:", len({atom.atom_type for atom in complex_structure})
)
print("Number of unique epsilons:", len({atom.epsilon for atom in complex_structure}))
print("Number of unique sigmas:", len({atom.sigma for atom in complex_structure}))
print()

print("BEFORE SYSTEM COMBINATION (just ligand)")
print(
    "Unique atom names:",
    sorted(list({atom.atom_type.name for atom in new_ligand_structure})),
)
print(
    "Number of unique atom types:",
    len({atom.atom_type for atom in new_ligand_structure}),
)
print(
    "Number of unique epsilons:", len({atom.epsilon for atom in new_ligand_structure})
)
print("Number of unique sigmas:", len({atom.sigma for atom in new_ligand_structure}))
print()

# Add the ligand
complex_structure += parmed.amber.AmberParm.from_structure(new_ligand_structure)

print("AFTER LIGAND ADDITION (protein+ligand)")
print(
    "Unique atom names:",
    sorted(list({atom.atom_type.name for atom in complex_structure})),
)
print(
    "Number of unique atom types:", len({atom.atom_type for atom in complex_structure})
)
print("Number of unique epsilons:", len({atom.epsilon for atom in complex_structure}))
print("Number of unique sigmas:", len({atom.sigma for atom in complex_structure}))




# Add ions
just_ion1_structure = parmed.Structure()
just_ion1_structure += pieces[2][0]
just_ion1_structure *= len(pieces[2][1])

just_ion2_structure = parmed.Structure()
just_ion2_structure += pieces[3][0]
just_ion2_structure *= len(pieces[3][1])

just_ion3_structure = parmed.Structure()
just_ion3_structure += pieces[4][0]
just_ion3_structure *= len(pieces[4][1])

complex_structure += parmed.amber.AmberParm.from_structure(just_ion1_structure)
complex_structure += parmed.amber.AmberParm.from_structure(just_ion2_structure)
complex_structure += parmed.amber.AmberParm.from_structure(just_ion3_structure)

print("AFTER ION ADDITION (protein+ligand+ions)")
print(
    "Unique atom names:",
    sorted(list({atom.atom_type.name for atom in complex_structure})),
)
print(
    "Number of unique atom types:", len({atom.atom_type for atom in complex_structure})
)
print("Number of unique epsilons:", len({atom.epsilon for atom in complex_structure}))
print("Number of unique sigmas:", len({atom.sigma for atom in complex_structure}))






# Add waters

just_water_structure = parmed.Structure()
just_water_structure += pieces[5][0]
just_water_structure *= len(pieces[5][1])

complex_structure += parmed.amber.AmberParm.from_structure(just_water_structure)

print("AFTER WATER ADDITION (protein+ligand+ions+water)")
print(
    "Unique atom names:",
    sorted(list({atom.atom_type.name for atom in complex_structure})),
)
print(
    "Number of unique atom types:", len({atom.atom_type for atom in complex_structure})
)
print("Number of unique epsilons:", len({atom.epsilon for atom in complex_structure}))
print("Number of unique sigmas:", len({atom.sigma for atom in complex_structure}))



# Copy over the original coordinates and box vectors
complex_structure.coordinates = orig_structure.coordinates
complex_structure.box_vectors = orig_structure.box_vectors


# Export the Structure to AMBER files
complex_structure.save("box.prmtop", overwrite=True)
complex_structure.save("box.inpcrd", overwrite=True)
complex_structure.save("box.pdb", overwrite=True)