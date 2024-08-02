import numpy
import loos
import loos.pyloos
import sys


class RNAligandAnalyzer:

    def __init__(self,
                 modelFile,
                 trajFile,
                 cutoffDistance,
                 rnaSelectionString,
                 ligSelectionString,
                 referenceFile=None):

        # Test property
        self.blah = "blah!"

        # LOOS Reading model and Trajectory
        self.model = loos.createSystem(modelFile)
        self.traj = loos.pyloos.Trajectory(trajFile, self.model)
        self.cutoff = cutoffDistance

        # Selection Strings
        self.rnaSelection = rnaSelectionString
        self.ligSelection = ligSelectionString

        # Parse reference file
        if referenceFile is not None:
            self.referenceFile = referenceFile
            self.refFileModel = loos.createSystem(referenceFile)

        # LOOS selecting RNA atoms : This is a LOOS AG
        self.rna = loos.selectAtoms(self.model, self.rnaSelection)
        # LOOS splitting RNA atoms to their residues : This is a python list
        self.rnaResidues = self.rna.splitByResidue()
        # LOOS selecting ligand atoms
        self.lig = loos.selectAtoms(self.model, self.ligSelection)
        # LOOS splitting ligand atoms to their residues
        self.ligResidues = self.lig.splitByResidue()

    # ---------------------------------------------------------------------- #
    #                               Testing                                  #
    # ---------------------------------------------------------------------- #

    def blahGenerator(self):
        '''
        Legacy test function to check class property. To be removed or
        to be turned into a full-help function later.
        '''
        return (print(self.blah))

    # ---------------------------------------------------------------------- #
    #                        Pocket Definition Tools                         #
    # ---------------------------------------------------------------------- #

    def contactsInfo(self, fullTraj=True, frameNum4PocketDefinition=0):
        '''
        This function returns the following outputs,

        0. contactsNormalized : A numpy 2D array of dimensions corresponding
                                to no. of RNA residues, and ligand residues.
                                The array consists of probability of a RNA
                                residue in proximity to a ligand residue for
                                a given cutoff distance. This probability is
                                normalized by the number of trajectory frames.
                                This gives a picture about RNA residues that
                                are part of binding pocket and how they are
                                consistent over the length of trajectory given.
        1. bindingPocketResidues : A dictionary that has resID of respective
                                RNA residues that are part of the binding
                                pocket as VALUE for given KEY frame. Both resID
                                and frame numbers are 0-indexed.

        Optional arguments:

        1. fullTraj (Bool) : Whether to choose full trajectory or not for
                             defining binding pocket. Default = True.
                             If false: Binding pocket is decided based on
                             a given frame of the trajectory.
        2. frameNum4PocketDefinition : The frame of the trajectory considered
                             for determining the binding pocket. Default = 0.
        '''
        # Initializing dict
        bindingPocketResidues = {}

        if fullTraj:

            # Initializing sanity matrix to check "empty pockets"
            emptyResInPockets = numpy.zeros([len(self.traj), ])

            # Initializing contact matrix
            contacts = numpy.zeros(
                [len(self.rnaResidues),
                    len(self.ligResidues),
                    len(self.traj)])
            # Initializing the frame counter
            frameID = 0
            # Looping over each frame to find out which RNA residue i is
            # in contact with Ligand residue j for a give given cutoff
            for frame in self.traj:
                for i in range(len(self.rnaResidues)):
                    for j in range(len(self.ligResidues)):
                        # Checking for contact
                        if self.rnaResidues[i].contactWith(
                                self.cutoff,
                                self.ligResidues[j]):
                            contacts[i, j, frameID] += 1.0

                # Extracting non zero indices (Basically, 0-indexed resID of
                # residues that are in contact with ligand)
                # if ligand has more than 1 residue, this may results in
                # nonZeroIndices having multiple entries corresponding to same
                # RNA residue as it interact with multiple ligand residue. But
                # we only need the unique set of RNA residues. numpy.unique
                # make sure that we only have a unique set of RNA residues.
                nonZeroIndices = numpy.argwhere(contacts[:, :, frameID] > 0)
                resArray = numpy.unique(nonZeroIndices[:, 0])

                # Sanity Check - Part 1/2
                # Checking if there's an empty pocket in a given frame
                if resArray.size == 0:
                    emptyResInPockets[frameID] = 1.0

                # Storing RNA binding pocket resIDs in dict
                bindingPocketResidues[frameID] = resArray
                # Incrementing frame counter
                frameID += 1

            # Normalizing contact matrix by number of frames
            contactsSum = numpy.sum(contacts, axis=2)
            contactsNormalized = contactsSum/len(self.traj)

            # Sanity Check - Part 2/2
            # Provided there's at least once occurrence of empty binding
            # pocket, warn the user.
            emptyPocketsFound = numpy.nonzero(emptyResInPockets)[0]
            if emptyPocketsFound.size != 0:
                print("""
-------------------------------------------------------------------------
****************************** !WARNING! ********************************
Change your cutoff criterion or reconsider your binding pose as no RNA
residues were found within {0} A cutoff in following (0-indexed) frames :
{1}
-------------------------------------------------------------------------
""".format(self.cutoff, emptyPocketsFound))

        else:

            # Initializing contact matrix
            contacts = numpy.zeros(
                [len(self.rnaResidues),
                    len(self.ligResidues)])

            # Defining model and selection specific to frame we need.
            frameModel = self.traj.readFrame(frameNum4PocketDefinition)
            frameRNA = loos.selectAtoms(frameModel,
                                            self.rnaSelection)
            frameRNAresidues = frameRNA.splitByResidue()
            frameLig = loos.selectAtoms(frameModel,
                                                self.ligSelection)
            frameLigResidues = frameLig.splitByResidue()

            # Iterating over RNA and ligand residues to find close
            # contacts
            for i in range(len(frameRNAresidues)):
                for j in range(len(frameLigResidues)):
                    # Checking for contact
                    if frameRNAresidues[i].contactWith(
                                        self.cutoff,
                                        frameLigResidues[j]):
                        contacts[i, j] = 1.0

            # Extracting non zero indices (Basically, 0-indexed resID of
            # residues that are in contact with ligand)
            # if ligand has more than 1 residue, this may results in
            # nonZeroIndices having multiple entries corresponding to same
            # RNA residue as it interact with multiple ligand residue. But
            # we only need the unique set of RNA residues. numpy.unique
            # make sure that we only have a unique set of RNA residues.
            nonZeroIndices = numpy.argwhere(contacts > 0)
            resArray = numpy.unique(nonZeroIndices[:, 0])

            # Sanity Check - Part 1/2
            # Checking if there's an empty pocket in a given frame
            if resArray.size == 0:
                print("""
    ---------------------------------------------------------------------------
    ******************************* !WARNING! *********************************
    Change your cutoff criterion or reconsider reference frame in traj or
    re-evaluate your your binding pose as no RNA or check the selection strings
    for RNA/ligand as residues were found within {0} A cutoff in the ref frame
    {1} that you gave for determining the binding pocket.
    ---------------------------------------------------------------------------
    """.format(self.cutoff, (frameNum4PocketDefinition + 1)))

            # Storing RNA binding pocket resIDs in dict
            bindingPocketResidues[frameNum4PocketDefinition] = resArray

            contactsNormalized = contacts

        # Including into class structure
        self.contactProbability = contactsNormalized
        self.bindingPocketResidues = bindingPocketResidues

        return(contactsNormalized, bindingPocketResidues)

    def dict2NumpyArray(self, Dictionary):
        '''
        A simple function to convert a dictionary to a numpy array
        '''
        itemizedGroup = Dictionary.items()

        # Convert object to a list
        dataList = list(itemizedGroup)

        # Convert list to an array
        numpyArray = numpy.array(dataList)

        return(numpyArray)

    def candidateResID2pocketResidues(self, candidateResIDs):
        '''
        Returns a LOOS AG corresponding to pocket RNA residues from
        candidateResID numpy array.
        This is a internal helper function to reduce code duplication
        in definePocketBy.... functions.
        This internal function does three things to input array:

        1. We extract unique i indices that corresponds to RNA.
        2. Compiling RNA residues corresponding to unique i indices
        3. Including into class structure
        '''
        # If candidate array is empty. Warn user and exit.
        if candidateResIDs.size == 0:
            sys.exit("""
            ------------------------------------------------------------------
            No residues were found in pocket region defined. Exiting..

            You may want to check the following :

            0. If you are using definePocketByTrajPrevalence():

                Did you explicitly give minimum fraction of trajectory arg?

                If yes, there may be no residues that meet that criterion.
                    Try lowering the value. Or check the contactNormalized
                    matrix to see what's the probability range.
                If no, the default value = 0.75 and there are no residue that
                    meet this criterion. After checking the contactNormalized
                    matrix, explicitly provide a sensible arg value.

            1. Is your cutoff distance adequate ? May be change the cutoff?

            2. Is your selection string the way you want it to be?

            3. Maybe the binding pose you considered is not as good as you
                thought? Try eyeballing the trajectory using some visualization
                software.

            4. You might have found a bug in this code : Time to wear your dev
               hat ;)
            ------------------------------------------------------------------
            """)

        # Here we extract unique i indices that corresponds to RNA.
        pocketResIDs = numpy.unique(candidateResIDs[:, 0])

        # Converting numpy array into list
        pocketResIDlist = list(pocketResIDs)

        # Initiating an empty list for storing strings
        pocketResIDStringList = []

        # Iterating through int list and creating a str list.
        # Converting resID from 0-indexed (python) to 1-indexed
        # (PDB compatible).
        for x in range(len(pocketResIDlist)):
            pocketResIDStringList.append("resid == {0}".format(str((pocketResIDlist[x] + 1))))

        # Concatenating strings with appropriate filler string for LOOS parsing
        selectionString = " || ".join(pocketResIDStringList)

        pocketSelectionString = selectionString + " && (resname != 'WAT')"

        print("The binding pocket residues for given criteria:")
        print(pocketSelectionString)

        # Including into class structure
        self.pocketSelection = pocketSelectionString

        # LOOS selecting pocket atoms. Type : LOOS AG
        pocketAG = loos.selectAtoms(self.model, self.pocketSelection)

        # Including into class structure
        self.pocket = pocketAG

        return(pocketAG)

    def definePocketByAllInteractingResidues(self):
        '''
        This function returns the RNA binding pocket residues defined
        by following criterion:

        All the RNA residues that came close to ligand for the given
        cutoff distance at least once in trajectory.
        '''
        # This array store the [i, j] indices of all the residues that
        # meet the criterion
        candidateResIDs = numpy.argwhere(
            self.contactProbability > 0)

        # Calling helper function
        pocketRES = self.candidateResID2pocketResidues(candidateResIDs)

        return (pocketRES)

    def definePocketByTrajPrevalence(self, minFractionOfTraj=0.75):
        '''
        This function returns the RNA binding pocket residues defined
        by following criterion:

        Only those RNA residues that came close to ligand for the given
        cutoff distance at least X fraction of the trajectory.

        X is given by the input argument minFractionOfTraj.

        Default X value = 0.75 (This means at least 75% of the trajectory
        the binding pocket residues were close to ligand)
        '''

        # This array store the [i, j] indices of all the residues that
        # meet the criterion
        candidateResIDs = numpy.argwhere(
            self.contactProbability >= minFractionOfTraj)

        # Calling helper function
        pocketRES = self.candidateResID2pocketResidues(candidateResIDs)

        return (pocketRES)

    # ---------------------------------------------------------------------- #
    #                     Centroid or COM Evolution Tools                    #
    # ---------------------------------------------------------------------- #

    def findCentroidOf(self, residueAG):
        '''
        Returns an numpy array containing centroid (x, y, z) coords
        for input AtomicGroup.
        Examples of AG inputs are self.pocketResidues,
        self.rnaResidues, self.ligResidues
        '''
        return(residueAG.centroid())

    def findCOMof(self, residueAG):
        '''
        Returns a numpy array containing center of mass (x, y, z) coords
        for input AtomicGroup.
        Examples of AG inputs are self.pocketResidues,
        self.rnaResidues, self.ligResidues
        '''
        return(residueAG.centerOfMass())

    def centroidEvolutionOf(self, residueAG, skipEmptyPocketFrames=False):
        '''
        Returns a dict with numpy array with centroids of input AG as VALUES
        for each KEY frameID (0-indexed).
        Optional Argument : skipEmptyPocketFrames (default = False)
                            If true, skips those frames in which no target
                            residues were close to ligand residues within
                            the given cutoff distance. Assign the VALUE of
                            dict with a NaN instead of numpy array.
        '''
        centroidEvolution = {}
        frameID = 0
        for frame in self.traj:
            if skipEmptyPocketFrames:
                if self.bindingPocketResidues[frameID].size != 0:
                    centroidEvolution[frameID] = self.findCentroidOf(residueAG)
                else:
                    centroidEvolution[frameID] = float("nan")
                    print("Frame {0} -- !! Warning !! No target residues \
                        close to ligand residues within the given cutoff \
                        distance in this frame. Setting centroid \
                        value = nan".format(str(frameID + 1)))

            else:
                centroidEvolution[frameID] = self.findCentroidOf(residueAG)

            frameID += 1

        return(centroidEvolution)

    def comEvolutionOf(self, residueAG, skipEmptyPocketFrames=False):
        '''
        Returns a dict with numpy array with COM of input AG as VALUES
        for each KEY frameID (0-indexed).
        Optional Argument : skipEmptyPocketFrames (default = False)
                            If true, skips those frames in which no target
                            residues were close to ligand residues within
                            the given cutoff distance. Assign the VALUE of
                            dict with a NaN instead of numpy array.
        '''
        comEvolution = {}
        frameID = 0
        for frame in self.traj:
            if skipEmptyPocketFrames:
                if self.bindingPocketResidues[frameID].size != 0:
                    comEvolution[frameID] = self.findCOMof(residueAG)
                else:
                    comEvolution[frameID] = float("nan")
                    print("Frame {0} -- !! Warning !! No target residues \
                        close to ligand residues within the given cutoff \
                        distance in this frame. Setting centroid \
                        value = nan".format(str(frameID + 1)))

            else:
                comEvolution[frameID] = self.findCOMof(residueAG)

            frameID += 1

        return(comEvolution)

    def centroidEvolutionOfRNA(self,
                               skipFramesWithNoResiduesInPocket=False):
        return(self.centroidEvolutionOf(self.rna,
                                        skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def centroidEvolutionOfLigand(self,
                                  skipFramesWithNoResiduesInPocket=False):
        return(self.centroidEvolutionOf(self.lig,
                                        skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def centroidEvolutionOfPocket(self,
                             skipFramesWithNoResiduesInPocket=False):
        return(self.centroidEvolutionOf(self.pocket,
                                   skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def comEvolutionOfRNA(self,
                          skipFramesWithNoResiduesInPocket=False):
        return(self.comEvolutionOf(self.rna,
                                   skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def comEvolutionOfLigand(self,
                             skipFramesWithNoResiduesInPocket=False):
        return(self.comEvolutionOf(self.lig,
                                   skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def comEvolutionOfPocket(self,
                             skipFramesWithNoResiduesInPocket=False):
        return(self.comEvolutionOf(self.pocket,
                                   skipEmptyPocketFrames=skipFramesWithNoResiduesInPocket))

    def distanceBetweenDict1andDict2(self, Dict1, Dict2):

        '''
        Provided Dict1 and Dict2, this function returns a numpy array
        where axis 0 is frameID and axis 1 is
        [(Dict1[frameID]-Dict2[frameID])^2]^0.5
        which is basically euclidean distance between Dict1 and Dict2 for
        given frameID.

        This function is intended to calculate the distance between Dict1 key
        value and Dict2 key value.

        Example use case : Get the distance between centroid of pocket and
        ligand over the trajectory
        '''
        distanceDict = {}
        for frameID in range(len(self.traj)):
            currentFrame = (self.traj).frame()
            box = currentFrame.periodicBox()
            distanceDict[frameID] = float((Dict1[frameID]).distance(Dict2[frameID], box))

        numpyArray = self.dict2NumpyArray(distanceDict)
        return(numpyArray)

    def comDistanceBetweenPocketAndLigand(self, skipEmptyPocketFrames=False):

        # Calculating COM evolution
        pocketCOMevolution = self.comEvolutionOfPocket(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)
        ligandCOMevolution = self.comEvolutionOfLigand(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)

        # Calculating distance between COMs
        distanceArray = self.distanceBetweenDict1andDict2(pocketCOMevolution,
                                                          ligandCOMevolution)

        return(distanceArray)

    def comDistanceBetweenRNAAndLigand(self, skipEmptyPocketFrames=False):

        # Calculating COM evolution
        RNAcomEvolution = self.comEvolutionOfRNA(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)
        ligandCOMevolution = self.comEvolutionOfLigand(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)

        # Calculating distance between COMs
        distanceArray = self.distanceBetweenDict1andDict2(RNAcomEvolution,
                                                          ligandCOMevolution)

        return(distanceArray)

    def centroidDistanceBetweenPocketAndLigand(self,
                                               skipEmptyPocketFrames=False):

        # Calculating COM evolution
        pocketCentroidEvolution = self.centroidEvolutionOfPocket(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)
        ligandCentroidevolution = self.centroidEvolutionOfLigand(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)

        # Calculating distance between COMs
        distanceArray = self.distanceBetweenDict1andDict2(pocketCentroidEvolution,
                                                          ligandCentroidevolution)

        return(distanceArray)

    def centroidDistanceBetweenRNAAndLigand(self,
                                       skipEmptyPocketFrames=False):

        # Calculating COM evolution
        RNAcentroidEvolution = self.centroidEvolutionOfRNA(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)
        ligandCentroidEvolution = self.centroidEvolutionOfLigand(skipFramesWithNoResiduesInPocket=skipEmptyPocketFrames)

        # Calculating distance between COMs
        distanceArray = self.distanceBetweenDict1andDict2(RNAcentroidEvolution,
                                                          ligandCentroidEvolution)

        return(distanceArray)

    # ---------------------------------------------------------------------- #
    #                           RMSD Evolution Tools                         #
    # ---------------------------------------------------------------------- #

    def rmsdIteratingOverTrajFunc(self, refAG, selection):
        """
        A internal helper function to reduce the code duplication
        while calculating rmsd evolution.

        Returns a dict with key-value pair given by 0-indexed frame number
        (KEY) and VALUE is the corresponding rmsd between given reference
        AG (refAG) and AG of same selection in the given frame.
        """

        # Initializing dict to store values
        rmsdHistory = {}

        # Iterating over the traj frames
        # This is one way to go about this.
        for frameIndex in range(len(self.traj)):
            # Fetching model for each frame.
            currentModel = self.traj.readFrame(frameIndex)
            currentAG = loos.selectAtoms(currentModel, selection)
            # Depreciated : Found this to be an overkill!
            # Aligning before calculating rmsd using LOOS func alignOnto()
            # currentAG.alignOnto(refAG)
            rmsdHistory[frameIndex] = currentAG.rmsd(refAG)

        return(rmsdHistory)

    def rmsdBtwSelectionAndAndTrajFrame(self, selection, refFrameNumber=0):
        """
        Returns a numpy array with dim 0 corresponding to frame index
        (0-indexed) and dim 1 corresponding to rmsd between ref frame
        selection and selection in the respective frame.

        selection = selection string to create LOOS AG out of model
        refFrameNumber  = Reference frame number is an optional argument
                          (Default = 0 : Initial frame)
        """

        # Constructing model AG for reference Frame
        refModel = self.traj.readFrame(refFrameNumber)

        # Making a deep copy of reference AG that does not mutate
        # in each frame
        refAG = (loos.selectAtoms(refModel, selection)).copy()

        # Calculating RMSD evolution
        rmsdHistory = self.rmsdIteratingOverTrajFunc(refAG, selection)
        rmsdArray = self.dict2NumpyArray(rmsdHistory)

        return(rmsdArray)

    def rmsdBtwSelectionAndExternalStructure(self, selection):
        """
        Returns a numpy array with dim 0 corresponding to frame index
        (0-indexed) and dim 1 corresponding to rmsd between ref file
        (NOT FRAME) and selection in the respective frame.

        Reference file cane be a crystal structure or other PDBs.

        NOTE : You need to provide Ref file while defining the
                RNAligandAnalyzer object, Else this will fail.

        selection = selection string to create LOOS AG out of model
        refFrameNumber  = Reference frame number is an optional argument
                          (Default = 0 : Initial frame)
        """

        # Constructing model AG for reference file
        refModel = loos.createSystem(self.referenceFile)
        # Making a deep copy of reference AG that does not mutate
        # in each frame
        refAG = loos.selectAtoms(refModel, selection)

        # Calculating RMSD evolution
        rmsdHistory = self.rmsdIteratingOverTrajFunc(refAG, selection)
        rmsdArray = self.dict2NumpyArray(rmsdHistory)

        return(rmsdArray)

    def rmsdBtwRNAandExternalStructure(self):
        return(self.rmsdBtwSelectionAndExternalStructure(self.rnaSelection))

    def rmsdBtwLigandAndExternalStructure(self):
        return(self.rmsdBtwSelectionAndExternalStructure(self.ligSelection))

    def rmsdBtwPocketAndExternalStructure(self):
        return(self.rmsdBtwSelectionAndExternalStructure(self.pocketSelection))

    def rmsdBtwRNAandTrajFrame(self, refFrameID_0indexed=0):
        return(self.rmsdBtwSelectionAndAndTrajFrame(self.rnaSelection,
                                                    refFrameNumber=refFrameID_0indexed))

    def rmsdBtwLigandAndTrajFrame(self, refFrameID_0indexed=0):
        return(self.rmsdBtwSelectionAndAndTrajFrame(self.ligSelection,
                                                    refFrameNumber=refFrameID_0indexed))

    def rmsdBtwPocketAndTrajFrame(self, refFrameID_0indexed=0):
        return(self.rmsdBtwSelectionAndAndTrajFrame(self.pocketSelection,
                                                    refFrameNumber=refFrameID_0indexed))

