#!/bin/bash

# Set environment variables since cron doesn't load them
export JAVA_HOME=/usr/lib/jvm/java-6-sun
export EC2_HOME=/usr
export EC2_BIN=/usr/bin/
export PATH=$PATH:$EC2_HOME/bin
export EC2_CERT=/home/ubuntu/.aws/cert-YOURCERTHERE.pem
export EC2_PRIVATE_KEY=/home/ubuntu/.aws/pk-YOURPKHERE.pem
export EC2_URL=https://ec2.YOURINSTANCEREGIONHERE.amazonaws.com # Setup your availability zone here

# Get instance id of the current server instance
MY_INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)

# get list of locally attached volumes 
VOLUMES=$(ec2-describe-volumes | grep ${MY_INSTANCE_ID} | awk '{ print $2 }')
echo "Instance-Id: $MY_INSTANCE_ID" 

    # Create a snapshot for all locally attached volumes
    LOG_FILE=/home/ubuntu/AWSSnapshot/ebsbackup.log
    echo "********** Starting backup for instance $MY_INSTANCE_ID" >> $LOG_FILE
    for VOLUME in $(echo $VOLUMES); do
        echo "Backup Volume:   $VOLUME" >> $LOG_FILE
        ec2-consistent-snapshot --aws-access-key-id YOURACCESSKEY --aws-secret-access-key YOURSECRETACCESSKEY --mysql --mysql-host localhost --mysql-username root --mysql-password YOURMYSQLPASSWORD --description "Backup ($MY_INSTANCE_ID) $(date +'%Y-%m-%d %H:%M:%S')" --region YOURINSTANCEREGIONHERE $VOLUME
done
echo "********** Ran backup: $(date)" >> $LOG_FILE

# Check if there are snapshots older than a certain number of days and delete them
echo "********** Checking for old snapshots..." >> $LOG_FILE
SNAPSHOTS=$(ec2-describe-snapshots | grep 'completed' | gawk -v days=30 -f AWSSnapshot/older_than_x_days.awk)

    # Delete old snapshots
    for SNAPSHOT in $(echo $SNAPSHOTS); do
        echo "Snapshot to delete:   $SNAPSHOT" >> $LOG_FILE
        ec2-delete-snapshot $SNAPSHOT
    done
echo "********** Deleted old snapshots!" >> $LOG_FILE

echo "Completed"
