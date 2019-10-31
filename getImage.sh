#!/bin/bash

# Seprating out the services that are only using Image from Harbor

source harborScan/config.properties

# Change the repo name below ..
# Assuming the Project Names in Harbor are different Department Names ....

Image_Name=$(sudo docker service ls | awk '$5 ~ /[REPO_NAME]/ { print $5 }')

mkdir -p $WORK_DIR/notifyTo

for Image_Name in ${Image_Name[@]};
do

# Seperating out the variables

Dept_Name=$(echo $Image_Name | awk -F / {'print $2'})
App_Name=$(echo $Image_Name | awk -F / {'print $3'} | awk -F : {'print $1'})
App_Version=$(echo $Image_Name | awk -F / {'print $3'} | awk -F : {'print $2'})

# Find out if the Image is vulnerable or not

$WORK_DIR/getVulnerabilities.sh --dept-name $Dept_Name --app-name $App_Name --app-version $App_Version

done

# Send an email only if any vulnerabilities are found

$WORK_DIR/sendEmail.sh
