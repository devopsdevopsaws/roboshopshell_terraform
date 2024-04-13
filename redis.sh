#!/bin/bash
uid=$(id -u)
date=$(date +%F)
script_name=$0
script_path=/home/centos/roboshopshell/logs
LOGFILE=$script_path/$script_name-$date.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
if [ $uid -ne 0 ]
then
echo -e " $R You are not a super user Please execute this script with super user $N "
exit 1
else
echo -e " $G Hey you are a super user, Running the script $N "
fi

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
    echo -e " $N $2 status is ......... $R FAILURE $N"
    exit 1
    else
    echo -e " $N $2 status is ..........$G SUCCESS $N"
    fi
}

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "Copied repor to repo directory"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "Copied redis repo directory"

yum install redis -y &>>$LOGFILE

VALIDATE $? "Install redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf &>>$LOGFILE

VALIDATE $? "change the IP"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "Enable redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "start redis"