#!/bin/bash

DBNAME=""
EXPIRATION="30"
Green='\033[0;32m'
EC='\033[0m' 
FILENAME=`date +%H_%M_%d%m%Y`

# terminate script on any fails
set -e

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -exp|--expiration)
    EXPIRATION="$2"
    shift
    ;;
    -db|--dbname)
    DBNAME="$2"
    shift
    ;;
esac
shift
done

if [[ -z "$DBNAME" ]]; then
  echo "Missing DBNAME variable"
  exit 1
fi
if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
  echo "Missing AWS_ACCESS_KEY_ID variable"
  exit 1
fi
if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
  echo "Missing AWS_SECRET_ACCESS_KEY variable"
  exit 1
fi
if [[ -z "$AWS_DEFAULT_REGION" ]]; then
  echo "Missing AWS_DEFAULT_REGION variable"
  exit 1
fi
if [[ -z "$S3_BUCKET_PATH" ]]; then
  echo "Missing S3_BUCKET_PATH variable"
  exit 1
fi
if [[ -z "$DATABASE_URL" ]]; then
  echo "Missing DATABASE_URL variable"
  exit 1
fi

printf "${Green}Start dump${EC}"
# Maybe in next 'version' use heroku-toolbelt
# /app/vendor/heroku-toolbelt/bin/heroku pg:backups capture $DATABASE --app $HEROKU_TOOLBELT_APP
# BACKUP_URL=`/app/vendor/heroku-toolbelt/bin/heroku pg:backups:public-url --app $HEROKU_TOOLBELT_APP | cat`
# curl --progress-bar -o /tmp/"${DBNAME}_${FILENAME}" $BACKUP_URL
# gzip /tmp/"${DBNAME}_${FILENAME}"

#time pg_dump $DATABASE_URL | gzip >  /tmp/"${DBNAME}_${FILENAME}".gz
time pg_dump -b -F c --dbname=$DATABASE_URL | gzip >  /tmp/"${DBNAME}_${FILENAME}".gz

#EXPIRATION_DATE=$(date -v +"2d" +"%Y-%m-%dT%H:%M:%SZ") #for MAC
EXPIRATION_DATE=$(date -d "$EXPIRATION days" +"%Y-%m-%dT%H:%M:%SZ")

printf "${Green}Move dump to AWS${EC}"
time /app/vendor/awscli/bin/aws s3 cp /tmp/"${DBNAME}_${FILENAME}".gz s3://$S3_BUCKET_PATH/$DBNAME/"${DBNAME}_${FILENAME}".gz --expires $EXPIRATION_DATE

# cleaning after all
rm -rf /tmp/"${DBNAME}_${FILENAME}".gz
