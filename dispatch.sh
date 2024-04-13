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

yum install golang -y &>>$LOGFILE

VALIDATE $? "Install golang"

useradd roboshop &>>$LOGFILE

mkdir /app  &>>$LOGFILE

curl -L -o /tmp/dispatch.zip https://roboshop-builds.s3.amazonaws.com/dispatch.zip &>>$LOGFILE

VALIDATE $? "downlaod soucecode of dispatch"

cd /app  &>>$LOGFILE

VALIDATE $? "move to app"

unzip /tmp/dispatch.zip &>>$LOGFILE

VALIDATE $? "unzip dispatch"

go mod init dispatch &>>$LOGFILE

go get &>>$LOGFILE

go build &>>$LOGFILE

VALIDATE $? "install dependencies"

cp -rp /home/centos/roboshopshell/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE

VALIDATE $? "Copied service file of dispatch"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system relaod"

systemctl enable dispatch &>>$LOGFILE

VALIDATE $? "enable dispatch"

systemctl start dispatch &>>$LOGFILE

VALIDATE $? "start dispatch"