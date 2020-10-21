#!/bin/bash

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
echo -e '\t\t\t 5 (kTwoGammaToMuMedium)'
echo '--> config = 1 (p-Pb) or 2 (Pb-p)'
echo
exit
}


## starts action here

if [ -z $3 ]
then
errorMessage
fi


# tests on the first parameter: the year
if [ $1 = 2013 ]
then
year=$1
elif [ $1 = 2016 ]
then
year=$1
else
errorMessage
fi

Pb_gamma_emitter=0
# tests on the second parameter: the process
if [ $2 = 1 ]
then
process=kIncohJpsiToMu
Pb_gamma_emitter=true
elif [ $2 = 2 ]
then
process=kCohJpsiToMu
Pb_gamma_emitter=false
elif [ $2 = 3 ]
then
process=kIncohPsi2sToMu
Pb_gamma_emitter=true
elif [ $2 = 4 ]
then
process=kTwoGammaToMuLow
elif [ $2 = 5 ]
then
process=kTwoGammaToMuMedium
else
errorMessage
fi

# tests on the third parameter: the configuration (p-Pb or Pb-p)
if [ $3 = 1 ]
then
config="p-Pb"
elif [ $3 = 2 ]
then
config="Pb-p"
else
errorMessage
fi

echo
echo Process: $process
echo 'Configuration' $config
echo

mMin=1.3
mMax=2.3
rapMin=2.5
rapMax=4
clean
if test -f files/$process/tree-$year-$config.root ; then
root -l -q "ReadOutput.C(\"$process\", $year, \"$config\")"
fi
clean

root -l -q "GetXSection.C(\"$process\", $year, \"$config\", $Pb_gamma_emitter, $mMin, $mMax)"
echo
