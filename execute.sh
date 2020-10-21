#!/bin/bash

inputFile='/Users/aglaenzer/Softwares/Starlight/build/slight.in'
slightOut='/Users/aglaenzer/Softwares/Starlight/build/slight.out'

## variables
N_EVENTS=2000000

clean()
{
filesToDelete="*.so *.d *.pcm *ACLiC* *.in *.out *dict*"
for entry in $filesToDelete
do
if test -f $entry;
then
#echo Deleting $entry
rm $entry
fi
done
}

errorMessage()
{
echo
echo 'Error: please type ./execute.sh $year $prodMode $config'
echo 'with'
echo '--> year = 2013 or 2016'
echo -e '--> production mode =\t 1 (kIncohJpsiToMu)'
echo -e '\t\t\t 2 (kCohJpsiToMu)'
echo -e '\t\t\t 3 (kIncohPsi2sToMu)'
echo -e '\t\t\t 4 (kTwoGammaToMuLow)'
echo '--> config = 1 (p-Pb) or 2 (Pb-p)'
echo
exit
}

write()
{
echo 'OUTPUT_HEADER = 1' >> $inputFile
echo 'BEAM_1_Z =' $BEAM_1_Z'    #Z of projectile' >> $inputFile
echo 'BEAM_1_A =' $BEAM_1_A'   #A of projectile' >> $inputFile
echo 'BEAM_2_Z =' $BEAM_2_Z'   #Z of target' >> $inputFile
echo 'BEAM_2_A =' $BEAM_2_A'   #A of target' >> $inputFile
echo 'BEAM_1_GAMMA = '$BEAM_1_GAMMA'	 #Gamma of the colliding ion 1' >> $inputFile
echo 'BEAM_2_GAMMA = '$BEAM_2_GAMMA'	#Gamma of the colliding ion 2' >> $inputFile
echo 'W_MAX =' $W_MAX'   #Max value of w' >> $inputFile
echo 'W_MIN =' $W_MIN'    #Min value of w' >> $inputFile
echo 'W_N_BINS =' $W_N_BINS'    #Bins i w' >> $inputFile
echo 'RAP_MAX = 5    #max y' >> $inputFile
echo 'RAP_N_BINS =' $RAP_N_BINS'    #Bins i y' >> $inputFile
echo 'CUT_PT = 0 #Cut in pT? 0 = (no, 1 = yes)' >> $inputFile
echo 'PT_MIN = 0.0 #Minimum pT in GeV' >> $inputFile
echo 'PT_MAX = 20.0 #Maximum pT in GeV' >> $inputFile
echo 'CUT_ETA = 0 #Cut in pseudorapidity? (0 = no, 1 = yes)' >> $inputFile
echo 'ETA_MIN = -4 #Minimum pseudorapidity' >> $inputFile
echo 'ETA_MAX = -2.5 #Maximum pseudorapidity' >> $inputFile
echo 'PROD_MODE =' $PROD_MODE'     	#gg or gP switch (1 = 2-photon, 2 = coherent vector meson (narrow), 3 = coherent vector meson (wide), 4 = incoherent vector meson)' >> $inputFile
echo 'N_EVENTS =' $N_EVENTS'   	#Number of events' >> $inputFile
echo 'PROD_PID =' $PROD_PID'   	#Channel of interest' >> $inputFile
echo 'RND_SEED =' $RND_SEED' 	#Random number seed' >> $inputFile
echo 'OUTPUT_FORMAT = 2     #Form of the output' >> $inputFile
echo 'BREAKUP_MODE = 5     #Controls the nuclear breakup' >> $inputFile
echo 'INTERFERENCE = 0     #Interference (0 = off, 1 = on)' >> $inputFile
echo 'IF_STRENGTH = 1.    #% of interference (0.0 - 0.1)' >> $inputFile
#echo 'COHERENT = 1     #Coherent=1,Incoherent=0' >> $inputFile
#echo 'INCO_FACTOR = 1.    #percentage of incoherence' >> $inputFile
#echo 'BFORD = 9.5' >> $inputFile
echo 'INT_PT_MAX = 0.24  #Maximum pt considered, when interference is turned on' >> $inputFile
echo 'INT_PT_N_BINS = 120   #Number of pt bins when interference is turned on' >> $inputFile
echo 'XSEC_METHOD = 1' >> $inputFile
echo 'N_THREADS = 8' >> $inputFile
echo 'PYTHIA_FULL_EVENTRECORD = 1' >> $inputFile
echo 'PRINT_VM = 2' >> $inputFile
}

## starts action here

if [ -z $3 ]
then
errorMessage
fi

if test -f $inputFile;
then
    rm $inputFile
fi

# tests on the first parameter: the year
if [ $1 = 2013 ]
then
BEAM_1=4263.2
BEAM_2=1680.7
elif [ $1 = 2016 ]
then
BEAM_1=6927.0
BEAM_2=2731.1
else
errorMessage
fi

# tests on the second parameter: the process
if [ $2 = 1 ]
then
process=kIncohJpsiToMu
Pb_gamma_emitter=true
PROD_MODE=4
PROD_PID=443013
W_MAX=3.09738
W_MIN=3.09645
W_N_BINS=20
RAP_N_BINS=10000
RND_SEED=578537
elif [ $2 = 2 ]
then
process=kCohJpsiToMu
Pb_gamma_emitter=false
PROD_MODE=2
PROD_PID=443013
W_MAX=3.09738
W_MIN=3.09645
W_N_BINS=20
RAP_N_BINS=10000
RND_SEED=578537
elif [ $2 = 3 ]
then
process=kIncohPsi2sToMu
Pb_gamma_emitter=true
PROD_MODE=4
PROD_PID=444013
W_MAX=3.6876
W_MIN=3.68461
W_N_BINS=20
RAP_N_BINS=10000
RND_SEED=578537
elif [ $2 = 4 ]
then
process=kTwoGammaToMuLow
Pb_gamma_emitter=true
PROD_MODE=1
PROD_PID=13
W_MAX=5.0
W_MIN=0.4
W_N_BINS=$(bc <<< "($W_MAX - $W_MIN)*100")
RAP_N_BINS=10000
RND_SEED=912665125
echo $W_N_BINS
else
errorMessage
fi



# tests on the third parameter: the configuration (p-Pb or Pb-p)
if [ $3 = 1 ]
then
config="p-Pb"
BEAM_1_GAMMA=$BEAM_1
BEAM_2_GAMMA=$BEAM_2
BEAM_1_Z=1
BEAM_1_A=1
BEAM_2_Z=82
BEAM_2_A=208
elif [ $3 = 2 ]
then
config="Pb-p"
BEAM_1_GAMMA=$BEAM_2
BEAM_2_GAMMA=$BEAM_1
BEAM_1_Z=82
BEAM_1_A=208
BEAM_2_Z=1
BEAM_2_A=1
else
errorMessage
fi

echo
echo Process: $process
echo 'Configuration' $config
echo


year=$1
dir=$PWD
write
outputFolder=$dir/files/$process
if ! test -d $outputFolder ; then
mkdir $outputFolder
fi

outputFile=${outputFolder}/output-$year-$config.txt

runStarlight=1

if [ $runStarlight = 1 ]; then
echo 'Writing in' $outputFile
cd /Users/aglaenzer/Softwares/Starlight/build
./starlight >& $outputFile&
echo 'Running Starlight...'
wait
echo 'Done'
#echo $outputFile
cd $dir
mv "$inputFile" "$outputFolder/slight-$year-$config.in"
mv "$slightOut" "$outputFolder/slight-$year-$config.out"
fi

clean
