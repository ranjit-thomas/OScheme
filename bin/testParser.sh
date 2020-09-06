#!/bin/bash

. $HOME/Desktop/OCamlPlayground/OScheme/bin/setEnv.sh
cd $projectDir
if [ ! -f "ParserTester.native" ]; then
	echo "Executable not found.  Please compile project with the 'buildAll.sh' script."
	exit 1
fi

./ParserTester.native