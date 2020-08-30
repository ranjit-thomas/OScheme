#!/bin/bash

. ./setEnv.sh
cd $projectDir
if [ ! -f "LexerTester.native" ]; then
	echo "Executable not found.  Please compile project with the 'buildAll.sh' script."
	exit 1
fi

./LexerTester.native