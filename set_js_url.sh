#!/bin/bash

WORKING_DIRECTORY=`dirname $0`

cd ${WORKING_DIRECTORY}
echo $(pwd)
CUBENAME=$(echo "$CLOUDCUBE_URL" | awk -F "/" ' { print $4 }')

sed "s/CUBENAME/${CUBENAME}/g" index-prod.html > static/index.html


