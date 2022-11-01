# Personal Resume Site Example

Simple Static Site hosted, to showcase usage of CI/CD automation using AWS Resources.

Pattern followed for site hosting Prod is Route53 -> Cloudfront -> S3 Bucket
![SiteHostingPattern](/site/imgs/SitePattern.png)
## Endpoints

Dev: 
- [RyanAParedes-dev.com.s3-website-us-east-1.amazonaws.com](http://RyanAParedes-dev.com.s3-website-us-east-1.amazonaws.com)

Prod:
- [RyanAParedes.com](https://ryanaparedes.com)

## Deployment & CI/CD
This repository is linked to CircleCI and configured to lauch 3 workflows:
- 1 to deploy site content Dev, then Prod (on Approval)
- 1 to plan and apply the dev environment infrastructure (On Approval)
- 1 to plan and apply the prod environment infrastructure.(On Approval)

See below for more detailed diagrams explaining flow.

### Overview of CI/CD Pattern
![CI/CD Overview](/site/imgs/CICDOverview.png)

## Todo / future changes
- Add more stlying/detail to site beyond hosting pdf resume
- Add automated checks for site health to fully automate prod deploy
- Add automated check/scripting to not plan terraform if no change
- Add prefix "www" support to Prod Cloudfront
- Add similar cloudfront pattern for dev environment
- Add more detail to diagrams.
- CI/CD flow optimizations (consolidating workflows/jobs)