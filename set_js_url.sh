#!/bin/bash


HEROKU_CONFIG=$(heroku config -a nlim)

CUBENAME=$(echo "$HEROKU_CONFIG" | grep  "CLOUDCUBE_URL" | awk '{ print $2 }' | awk -F "/" ' { print $4 }')

sed "s/CUBENAME/${CUBENAME}/g" static/index-prod.html > static/index.html


