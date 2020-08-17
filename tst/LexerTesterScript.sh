#!/bin/bash

projectDir=$HOME/Desktop/OCamlPlayground/OScheme
testDir=$projectDir/tst
expectedOutput=$(cat $testDir/ExpectedOutputs/LexerTesterExpectedOutput.txt)
actualOutput=$($projectDir/OScheme.native $testDir/InputScmFiles/LexerTesterInput.scm)

if [ "$expectedOutput" = "$actualOutput" ]
then
	echo "Success!"
else
	echo -e "Failure.\nEXPECTED:\n$expectedOutput\nACTUAL:\n$actualOutput"
fi