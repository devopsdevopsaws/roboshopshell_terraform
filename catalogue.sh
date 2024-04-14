#!/bin/bash
uid=$(id -u)
date=$(date +%F)
script_name=$0
script_path=/home/centos/roboshopshell_terraform/logs
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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Copied repo"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Install nodejs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downlaod code"

cd /app &>>$LOGFILE

VALIDATE $? "switch to app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unzip catalogue"

npm install &>>$LOGFILE

VALIDATE $? "Install dependenices"

cp -rp /home/centos/roboshopshell_terraform/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE

VALIDATE $? "Create and copy catalogue service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system reload"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "Enable catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "start catalogue"

cp -rp /home/centos/roboshopshell_terraform/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "copied mongo repo for client"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "Install mongodb client"

mongo --host mongodb.padmasrikanth.shop </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "Connect to Mongodb"

