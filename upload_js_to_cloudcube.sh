#!/bin/bash


HEROKU_CONFIG=$(heroku config -a nlim)

AWS_ACCESS_KEY_ID=$(echo "$HEROKU_CONFIG" | grep  "CLOUDCUBE_ACCESS_KEY_ID" | awk '{ print $2 }')
AWS_SECRET_ACCESS_KEY=$(echo "$HEROKU_CONFIG" | grep  "CLOUDCUBE_SECRET_ACCESS_KEY" | awk '{ print $2 }')
CUBENAME=$(echo "$HEROKU_CONFIG" | grep  "CLOUDCUBE_URL" | awk '{ print $2 }' | awk -F "/" ' { print $4 }')

echo "Copying all.min.js to s3"

AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY aws s3 cp static/all.min.js s3://cloud-cube/$CUBENAME/public/all.min.js
