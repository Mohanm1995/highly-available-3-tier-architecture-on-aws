# Highly Available AWS 3-Tier Architecture

This project is part of my hands-on AWS and DevOps learning journey. I built this architecture to understand how real world production infrastructure works on AWS.

---

## Why I Built This

When I started learning AWS, I wanted to go beyond just watching tutorials. I wanted to actually build something that reflects how companies run their applications in the cloud. So I designed and implemented this 3-tier architecture from scratch using core AWS services.

---

## What This Project Does

This is a fully functional highly available 3-tier architecture deployed on AWS. It separates the web layer, application layer, and database layer into different private subnets across two availability zones. The entire setup is containerized, monitored, and automated.

---

## AWS Services Used

VPC, EC2, Auto Scaling, Application Load Balancer, CloudFront, Route 53, S3, CloudWatch, SNS, IAM, Docker, Nginx, MariaDB, ACM, NAT Gateway, Internet Gateway, VPC Endpoint

---

## How Traffic Flows

User opens the website → GoDaddy resolves the domain → Route 53 routes to CloudFront → CloudFront delivers content over HTTPS → Public Load Balancer receives the request → Nginx Reverse Proxy forwards it internally → Internal Load Balancer distributes to application servers → Application processes the request → MariaDB returns the data

---

## Network Design

I created one custom VPC with two Availability Zones.

Inside the VPC:
- 2 Public Subnets for Load Balancer and NAT Gateway
- 6 Private Subnets for Web Tier, Application Tier, and internal routing

I used two availability zones so that if one zone goes down the application keeps running from the other zone.

---

## Security Design

This was one of the parts I focused on the most. No EC2 instance is directly exposed to the internet.

I implemented security group chaining:

- Public Load Balancer accepts HTTPS from internet
- Web Tier accepts traffic only from Public Load Balancer
- Internal Load Balancer accepts traffic only from Web Tier
- Application Tier accepts traffic only from Internal Load Balancer
- Database accepts traffic only from Application Tier

Every layer only talks to the layer directly above or below it. Nothing else.

---

## Web Tier

- Nginx is configured as a Reverse Proxy
- Deployed inside Private Subnets 1 and 2
- Auto Scaling based on ALB Request Count per Target (threshold: 50 requests per target)
- Health checks configured on Load Balancer target group

---

## Application Tier

- Application deployed using Docker
- MariaDB 10.5 installed locally on the same instance
- Deployed inside Private Subnets 5 and 6
- Auto Scaling based on CPU utilization above 50 percent

Note: In a production setup I would use Amazon RDS with Multi-AZ for the database layer instead of installing it locally.

---

## HTTPS and Domain Setup

- Domain registered on GoDaddy
- DNS managed through Route 53
- CloudFront configured for global content delivery
- TLS certificate created using ACM in North Virginia region for CloudFront
- Separate TLS certificate created for the Public Load Balancer
- End to end HTTPS encryption enabled

---

## Monitoring and Alerts

* CloudWatch monitors ALB Request Count per Target on the Web Tier
* CloudWatch monitors CPU utilization on the Application Tier
* Auto Scaling triggers when Request Count per Target crosses 50 requests (Web Tier) and CPU crosses 50 percent (Application Tier)
* SNS sends email notifications for every scaling event including instance launch and termination

---

## Log Management

- Nginx access.log and error.log collected from Web Tier instances
- Shell script written to compress logs with timestamp and upload to S3
- Crontab configured to run this script automatically every day at 6 PM
- Gateway VPC Endpoint created so logs travel to S3 through AWS private network without going through NAT Gateway

---

## Cost Optimizations I Applied

- Used single NAT Gateway instead of two to reduce hourly cost
- Used Gateway VPC Endpoint for S3 to eliminate NAT data charges for log uploads
- Used CloudFront caching to reduce origin server load
- Used locally installed MariaDB instead of RDS to avoid additional managed database cost

---

## What I Learned From This Project

- How to design a real multi-tier VPC network from scratch
- How security group chaining works in practice
- How Auto Scaling and Load Balancers work together for high availability
- How to set up end to end HTTPS using CloudFront and ACM
- How to automate operational tasks using shell scripting and crontab
- How VPC Endpoints reduce cost and improve security
- How to think about production readiness even in a demo project

---

## Screenshots

All implementation screenshots are available in the images folder.

---

## Project Status

Completed. Infrastructure was tested and verified. Resources deleted after project completion to avoid unnecessary AWS charges.

---

## Author

**Mohan M**

AWS and DevOps Engineer (Fresher)

---

## Acknowledgement

This project was built under the guidance of my trainer as part of the AWS and DevOps hands-on training program. All implementation, configuration, and documentation was done by me.

---
