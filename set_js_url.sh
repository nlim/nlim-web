#!/bin/bash

CUBENAME=$(echo "$CLOUDCUBE_URL" | awk -F "/" ' { print $4 }')

sed "s/CUBENAME/${CUBENAME}/g" index-prod.html > static/index.html


