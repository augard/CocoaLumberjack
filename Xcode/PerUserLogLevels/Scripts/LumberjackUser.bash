#!/bin/bash

# Get full user name of current user
# E.g. "Robbie Hanson"
full=$(osascript -e "tell application \"System Events\"" -e "get the full name of the current user" -e "end tell")
#echo $full

# Convert to lower case
# E.g. "robbie hanson"
full_lower=$(echo $full | awk '{print tolower($0)}')
#echo $full_lower

# Replace spaces with underscores
# E.g. "robbie_hanson"
full_lower_underscore=$(echo ${full_lower// /_})
#echo $full_lower_underscore

echo "// This file is automatically generated" > ${SRCROOT}/PerUserLogLevels/LumberjackUser.h
echo "#define $full_lower_underscore 1" >> ${SRCROOT}/PerUserLogLevels/LumberjackUser.h

# If we output directly to our intended file, even when nothing has changed,
# then we'll essentially be doing a touch on the file.
# The compiler will see this, and recompile any files that include the header.
# This may mean recompiling every single source file, every single time we do a build!
# So instead we're going to output to a temporary file, and use diff to detect changes.

temp_filepath="${SRCROOT}/PerUserLogLevels/LumberjackUser.temp.h"
final_filepath="${SRCROOT}/PerUserLogLevels/LumberjackUser.h"

echo "// This file is automatically generated" > ${temp_filepath}
echo "#define $full_lower_underscore 1" >> ${temp_filepath}

if [ -a ${final_filepath} ]
	then
	DIFF=$(diff ${temp_filepath} ${final_filepath}) 
	if [ "$DIFF" != "" ] 
	then
		cp -f ${temp_filepath} ${final_filepath}
	fi
else
	cp -f ${temp_filepath} ${final_filepath}
fi