#!/bin/bash

# Store redirect code
redirect=`cat redirect.html`;

# Exit if an error occurs
set -e;

# Pull the website while ignoring unnecessary pages
wget -m -k -E --no-check-certificate --reject-regex "(.*)(\?|\.gz|\.zip)(.*)" https://nmag.soton.ac.uk/community/wiki/nmag/;

# Renames the appropriate files to index.html
createIndexes(){

	# If there are directories to explore, set the directories variable appropriately
	if ls -d */ &> /dev/null; then
		directories=`ls -d */`;

	# Else, set directories to ''
	else
		directories='';
	fi

	# Iterate through all directories
	for directory in $directories; do
		cd $directory;
		createIndexes;
	done;

	# Find the files which have the same basename as a directory
	for name in `ls`; do
		basename=`echo $name | sed 's/\..*//g'`;
		
		# If there is an html file with a matching directory, then make index.html
		if [ -f $basename.html ] && [ -d $basename ] && [-d $name]; then
			cp $basename.html $name/index.html;
		fi;
	done;

	# Ascend the directory structure
	cd ..;
}

createIndexes;
