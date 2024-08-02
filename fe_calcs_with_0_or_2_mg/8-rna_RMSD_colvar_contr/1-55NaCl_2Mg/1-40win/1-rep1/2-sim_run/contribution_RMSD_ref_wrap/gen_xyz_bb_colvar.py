import os
import shutil
import subprocess
import sys

import numpy as np

from BFEE2.commonTools import fileParser

selectionLig = "all"

fParser = fileParser.fileParser( f'../ini/eq.pdb')
fParser.saveFile('all', f'complex.xyz', 'xyz')
