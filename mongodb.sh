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

cp -rp /home/centos/roboshopshell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "Copied repor to repo directory"

yum install mongodb-org -y &>>$LOGFILE

VALIDATE $? "Install mongodb"

systemctl enable mongod &>>$LOGFILE

VALIDATE $? "Enable mongodb"

systemctl start mongod  &>>$LOGFILE

VALIDATE $? "start mongodb"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf  &>>$LOGFILE

VALIDATE $? "change IP"

systemctl restart mongod  &>>$LOGFILE

VALIDATE $? "restart mongodb"