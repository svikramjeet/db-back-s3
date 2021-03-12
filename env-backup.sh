#!/bin/bash

FNAME="heroku-env-backup"
EXPIRATION="30"
Green='\033[0;32m'
EC='\033[0m' 
FILENAME=`date +%H_%M_%d%m%Y`
sourceApp="$1"

# terminate script on any fails
set -e

printf "${Green}Start env-dump${EC}"

#download heroku cli
# lgin to cli

time printenv  | gzip >  /tmp/"${FNAME}_${FILENAME}".gz

EXPIRATION_DATE=$(date -d "$EXPIRATION days" +"%Y-%m-%dT%H:%M:%SZ")

printf "${Green}Move env-backup to AWS${EC}"
time /app/vendor/bin/aws s3 cp /tmp/"${FNAME}_${FILENAME}".gz s3://$S3_BUCKET_PATH/$FNAME/"${FNAME}_${FILENAME}".gz --expires $EXPIRATION_DATE

# cleaning after all
rm -rf /tmp/"${FNAME}_${FILENAME}".gz
