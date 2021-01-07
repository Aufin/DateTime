#!/bin/bash

DT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/../.."
if [ "$1" = "debug" ]; then
	DEBUG="debug"
else
	OUT_DIR=$1
	DEBUG=$2
fi

# If not run from DataTables build script, redirect to there
if [ -z "$DT_BUILD" ]; then
	cd $DT_DIR/build
	./make.sh extension DateTime $DEBUG
	cd -
	exit
fi

# Change into script's own dir
cd $(dirname $0)

DT_SRC=$(dirname $(dirname $(pwd)))
DT_BUILT="${DT_SRC}/built/DataTables"
. $DT_SRC/build/include.sh

if [ ! -d node_modules ]; then
	npm install -dev
fi

gulp

js_compress dist/dataTables.dateTime.js
css_compress dist/dataTables.dateTime.css

rsync -r dist/* $OUT_DIR

# Readme and license
cp readme.md $OUT_DIR
cp license.txt $OUT_DIR
