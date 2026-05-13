#!/bin/bash

mkdir logs

zip nginx-log-"$(date +%d-%m-%y)".zip logs/

aws s3 mv nginx-log-"$(date +%d-%m-%y)".zip s3://aws-3-tier-project-nginx-log-bucket/

rm -rf logs
