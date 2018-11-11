#!/bin/bash

CUBENAME=$(echo "$CLOUDCUBE_URL" | awk -F "/" ' { print $4 }')

rm -f static/index.html
touch static/index.html

sed "s/CUBENAME/${CUBENAME}/g" index-prod.html > static/index.html


