#!/bin/bash

FNAME="om-env-backup"
EXPIRATION="30"
Green='\033[0;32m'
EC='\033[0m' 
FILENAME=`date +%H_%M_%d%m%Y`
<<<<<<< HEAD
sourceApp="$1"
=======
>>>>>>> c32e692385cc120bc5f27d6bd7406e78308f2c83

# terminate script on any fails
set -e

printf "${Green}Start env-dump${EC}"

<<<<<<< HEAD
#download heroku cli
# lgin to cli

time heroku config -s -a "$sourceApp"  | gzip >  /tmp/"${FNAME}_${FILENAME}".gz
=======
time pg_dump $DATABASE_URL | gzip >  /tmp/"${FNAME}_${FILENAME}".gz
>>>>>>> c32e692385cc120bc5f27d6bd7406e78308f2c83

EXPIRATION_DATE=$(date -d "$EXPIRATION days" +"%Y-%m-%dT%H:%M:%SZ")

printf "${Green}Move env-backup to AWS${EC}"
time /app/vendor/awscli/bin/aws s3 cp /tmp/"${FNAME}_${FILENAME}".gz s3://$S3_BUCKET_PATH/$FNAME/"${FNAME}_${FILENAME}".gz --expires $EXPIRATION_DATE

# cleaning after all
rm -rf /tmp/"${FNAME}_${FILENAME}".gz
