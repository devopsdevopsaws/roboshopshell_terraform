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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Copied repo"

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "Install nodejs"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>$LOGFILE

VALIDATE $? "downlaod code"

cd /app &>>$LOGFILE

VALIDATE $? "switch to app directory"

unzip /tmp/cart.zip &>>$LOGFILE

VALIDATE $? "unzip cart"

npm install &>>$LOGFILE

VALIDATE $? "Install dependenices"

cp -rp /home/centos/roboshopshell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE

VALIDATE $? "Create and user cart service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system reload"

systemctl enable cart &>>$LOGFILE

VALIDATE $? "Enable cart"

systemctl start cart &>>$LOGFILE

VALIDATE $? "start cart"
