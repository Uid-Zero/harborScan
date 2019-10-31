#!/bin/bash

source harborScan/config.properties

# Array pretending to be a Pythonic dictionary
# Add new Department names and Contacts to this array. 

Dept_Contact=( "Dept01:Email01"
               "Dept02:Email02"
               "Dept03:Email03"
	       "Dept04:Email04"
               "Dept05:Email05" )

# Find out the Env that this script is running in. 

if [ `hostname -f` = {DEV_HOST} ]
then
	Env=Dev
elif [ `hostname -f` = {TST_HOST} ]
then
	Env=Test
elif [ `hostname -f` = {PRD_HOST} ]
then
	Env=Prod
fi

# Please note that the variables Dept and Dept_Name represent same value but since they are running in diif scripts - They are mentioned twice. 

for Value in "${Dept_Contact[@]}" ; do
    Dept="${Value%%:*}"
    Contact="${Value##*:}"
    
    if [ -f "$WORK_DIR/notifyTo/$Dept" ]; then
	    echo -e "As of $(date '+%A %m %Y %X'), these attached application images are vulnerable.\\nPlease log in to Harbor [REPO_NAME] to get more details about the vulnerabilities. \\n\\nThank You, \\nCouncil of *NIX Services and Virtualization Headquarters." | mailx -s "Harbor scan report - $Env Docker WebFarm" -a $WORK_DIR/notifyTo/$Dept -r [EMAIL_ID TO SEND AS..] $Contact
    fi
done

if [ -f $WORK_DIR/vulnerableImages.txt ]; then
            echo -e "As of $(date '+%A %m %Y %X'), these attached application images are vulnerable.\\nDevelopers have been informed about these vulnerabilities." | mailx -s "Harbor scan report - $Env Docker WebFarm" -a $WORK_DIR/vulnerableImages.txt -r [EMAIL_ID TO SEND AS...] [SERVICE_OWNER/DEPT ID]
fi
