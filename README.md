ebs-manage-snapshot
===================

A small script to help automatically make AWS EBS snapshots. This script can also delete snapshots older than a certain number of days. Based on [this script](http://stackoverflow.com/questions/9667390/how-to-automatically-snapshot-a-volume-of-an-amazon-ec2-instance) and [this StackOverflow question](http://stackoverflow.com/questions/9667390/how-to-automatically-snapshot-a-volume-of-an-amazon-ec2-instance). 

Setup
-----------
- Install [ec2-consistent-snapshot](https://github.com/alestic/ec2-consistent-snapshot) and gawk (sudo apt-get install gawk). 
- Create the AWSSnapshot folder in your home directory and place snapshot.sh and older_than_x_days.awk inside.
- Open snapshot.sh in a text editor and fill in your AWS credentials where indicated. There are places to fill in this information near the top of the file where environment variables are listed, and on the line that says 'ec2-consistent-snapshot'. You'll have to visit [your AWS security credentials page](https://console.aws.amazon.com/iam/home?#security_credential) to download your Access Keys and X.509 Certificates. 
- On the line that says 'ec2-consistent-snapshot', make sure to fill in your MySQL credentials. 
- On the line that says 'ec2-describe-snapshots', make sure to change the 'days' parameter to indicate how old of snapshots you want to keep.
- Save snapshot.sh, and use chmod to make it executable.
- Create a cronjob to run snapshot.sh however often you like.
