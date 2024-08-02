import os
import shutil
import subprocess
import sys

import numpy as np

from BFEE2.commonTools import fileParser

selectionLig = "all"

fParser = fileParser.fileParser( f'../../1-sys_prep/box.pdb')
fParser.saveFile('all', f'complex.xyz', 'xyz')
