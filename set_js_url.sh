#!/bin/bash

WORKING_DIRECTORY=`dirname $0`
echo $WORKING_DIRECTORY

cd ${WORKING_DIRECTORY}

CUBENAME=$(echo "$CLOUDCUBE_URL" | awk -F "/" ' { print $4 }')

sed "s/CUBENAME/${CUBENAME}/g" index-prod.html > static/index.html


