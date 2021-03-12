## Heroku Buildpack: heroku-db-backup-s3
Capture DB backup & copy to s3 bucket. support heroku 18 and heroku 20 stack

### Installation
Add buildpack to your Heroku app
```
heroku buildpacks:add https://github.com/svikramjeet/db-back-s3 --app <your_app>
```
> Buildpacks are scripts that are run when your app is deployed.

### Configure environment variables
```
heroku config:add AWS_ACCESS_KEY_ID=XXX --app <your_app>
heroku config:add AWS_SECRET_ACCESS_KEY=YYY --app <your_app>
heroku config:add AWS_DEFAULT_REGION=region --app <your_app> (region example eu-west-1)
heroku config:add S3_BUCKET_PATH=bucket_name --app <your_app>

```
Go to settings page of your Heroku application and add Config Var `DBURL_FOR_BACKUP` with the same value as var `DATABASE_URL`. This is our DB connection string.

### Scheduler
Add addon scheduler to your app. 
```
heroku addons:create scheduler --app <your_app>
```
Create scheduler.
```
heroku addons:open scheduler --app <your_app>
```
Now in browser `Add new Job`.

Add different as mentioned below:

> For DB backup
`bash /app/vendor/backup.sh -db <somedbname>`
and configure FREQUENCY. Paramenter `db` is used for naming convention when we create backups. We don't use it for dumping  database with the same name.

> For DNS backup
`bash /app/vendor/dns-backup.sh domainname`
Paramenter `domainname` is used for domain eg google.com, please donot add http:// or https.


> For ENV backup
`bash /app/vendor/env-backup.sh`


## Road map
Here's the plan for what's coming:

- [x] DB backup on S3
- [x] DNS backup on S3
- [x] env backup on S3
- [ ] Remove backup after 1 month from S3
- [ ] Keep back  of 1st day of every month
- [ ] Encrypt database

And here are some ideas I'm still not sure about:
- [ ] Slack notification on each backup
- [ ] Backup before each deploy
- [ ] Add option to backup on GCP
