# Personal Resume Site Example

Simple Static Site hosted, to showcase usage of CI/CD automation using AWS Resources.

Pattern followed for site hosting Prod is Route53 -> Cloudfront -> S3 Bucket
![SiteHostingPattern](/imgs/SitePattern.png)
## Endpoints

Dev: 
- RyanAParedes-dev.com.s3-website-us-east-1.amazonaws.com/

Prod:
- RyanAParedes.com

## Deployment & CI/CD
This repository islinked to CircleCI and configured to lauch 3 workflows, 1 to deploy site content, 1 to plan and apply the dev environment infrastructure, and 1 to plan and apply the prod environment infrastructure.

See below for more detailed diagrams explaining flow.

### Overview of CI/CD Pattern
![CI/CD Overview](/imgs/CICDOverview.png)

## Todo / future changes
- Add more stlying/detail to site beyond hosting pdf resume
- Add prefix "www" support to Prod Cloudfront
- Add similar cloudfront pattern for dev environment
- Add more detail to diagrams.
- CI/CD flow optimizations (consolidating workflows/jobs)