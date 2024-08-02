'''
1-Parses command-line arguments using the argparse module to allow the user to specify the path to a small molecule SDF file.
2-Reads an AMBER topology and coordinate file and creates a parmed.amber.AmberParm object.
3-Splits the AmberParm object into its constituent pieces (i.e., separate parmed.Structure objects for each residue).
4-Prints the name of each piece and the number of times it appears in the original AmberParm object.
5-Imports the PDBFile class from the openmm.app module, or the simtk.openmm.app module if the former is not available.
6-Uses the Molecule class from the openff.toolkit.topology module to create a Molecule object from the SDF file specified by the user.
7-Converts the Molecule object to a Topology object.
8-Loads the SMIRNOFF-format Sage force field using the ForceField class from the openff.toolkit.typing.engines.smirnoff module.
9-Creates an OpenMM system using the Topology object and the Sage force field.
10-Uses the parmed.openmm.load_topology() function to create a parmed.Structure object from the Topology object and the OpenMM system.
11-Saves the new parmed.Structure object as a new AMBER topology and coordinate file.
12-Add the other elements (ions and waters)
'''
import argparse

# Creating an ArgumentParser object
argParser = argparse.ArgumentParser()
# Adding an argument to the ArgumentParser object
argParser.add_argument("-s", "--sdf", help="small molecule sdf file")
# Parsing the added argument
args = argParser.parse_args()

#Importing the required library for the conversion
import parmed
# Read AMBER to ParmEd Structure object
# Creating a parmed object by reading the Amber topology and coordinate files
in_prmtop = "box_gaff.prmtop"
in_crd = "box_gaff.inpcrd"
orig_structure = parmed.amber.AmberParm(in_prmtop, in_crd)

#Splitting the structure into pieces and printing the number of instances of each piece
pieces = orig_structure.split()
for piece in pieces:
    print(f"There are {len(piece[1])} instance(s) of {piece[0]}")



# Importing libraries to convert to OpenMM
try:
    from openmm.app import PDBFile
except ImportError:
    from simtk.openmm.app import PDBFile

from openff.toolkit.topology import Molecule, Topology

# Converting the ligand SDF file to OpenFF Molecule object
ligand_off_molecule = Molecule(args.sdf)
# Converting the OpenFF Molecule object to OpenMM topology object
ligand_off_topology = ligand_off_molecule.to_topology()



# Load the SMIRNOFF-format Sage force field
# Importing library for the SMIRNOFF force field
from openff.toolkit.typing.engines.smirnoff import ForceField

# Creating the Sage SMIRNOFF force field object
force_field = ForceField("openff_unconstrained-2.0.0.offxml")

# Creating an OpenMM system for the ligand using the SMIRNOFF force field
ligand_system = force_field.create_openmm_system(ligand_off_topology)
# Creating a ParmEd structure object from the OpenMM topology and system objects
new_ligand_structure = parmed.openmm.load_topology(
    ligand_off_topology.to_openmm(),
    ligand_system,
    xyz=pieces[1][0].positions,
)

# Saving the ParmEd structure object as PRMTOP and INPCRD files
new_ligand_structure.save("tmp.prmtop", overwrite=True)
new_ligand_structure.save("tmp.inpcrd", overwrite=True)


# Check how many atoms and which order elements are in the new ligand
# Checking the number of atoms and element types in the old and new ligand structures
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
# Creating an empty ParmEd structure object to hold the final system
complex_structure = parmed.Structure()

# Add the RNA. Convert explicitly to an AmberParm object to ensure that 1-4 scaling factors are preserved.
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