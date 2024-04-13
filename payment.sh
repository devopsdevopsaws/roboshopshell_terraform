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

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "Install python"

useradd roboshop &>>$LOGFILE

VALIDATE $? "create user"

mkdir /app &>>$LOGFILE

VALIDATE $? "create app directory"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "download payment source code"

cd /app &>>$LOGFILE

VALIDATE $? "move to app"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "unzip payment"

pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "install dependencies "

cp -rp /home/centos/roboshopshell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE

VALIDATE $? "copy payment service "

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system reload"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "enable payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "start payment"