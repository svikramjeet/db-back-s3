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


## AWS Bucket Policy
This buildpack requires specific policy allows a user, identified by their Amazon Resource Name (ARN), to perform the s3:PutObject action on an Amazon S3 bucket. The Effect is set to "Allow," indicating that this permission is granted.Here is sample bucket policy json:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": <USER_ARN>
            },
            "Action": ["s3:PutObject"],
            "Resource": [
                "arn:aws:s3:::<Bucket name>",
                "arn:aws:s3:::<Bucket name>/*"
            ],
            "Condition": {
                "StringEquals": {
                    "aws:PrincipalArn": <USER_ARN>
                }
            }
        }
    ]
}
```


The Resource field specifies the ARN of the bucket (arn:aws:s3:::<Bucket name>) and its contents (arn:aws:s3:::<Bucket name>/*), indicating that the user can perform the PutObject action on any object within the specified S3 bucket.

The Condition field restricts the policy to the specific user identified by the aws:PrincipalArn condition key. This condition ensures that the policy applies only if the user's ARN matches the one specified in the Principal field.

Please note that <USER_ARN> and <Bucket name> are placeholders in the policy, and you would need to replace them with the appropriate values specific to your AWS environment.USER_ARN format looks like `arn:aws:iam::ID:user/USER_NAME`
