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

yum install maven -y &>>$LOGFILE

VALIDATE $? "install Maven"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "copy shipping"

cd /app &>>$LOGFILE

VALIDATE $? "switch to app"

unzip /tmp/shipping.zip &>>$LOGFILE

VALIDATE $? "unzip shipping"

mvn clean package &>>$LOGFILE

VALIDATE $? "install dependencies"

mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE

VALIDATE $? "rename file"

cp -rp /home/centos/roboshopshell/shipping.service /etc/systemd/system/shipping.service &>>$LOGFILE

VALIDATE $? "copy shipping service"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "system relaod"

systemctl enable shipping &>>$LOGFILE

VALIDATE $? "enable shipping"

systemctl start shipping &>>$LOGFILE

VALIDATE $? "start shipping"

yum install mysql -y &>>$LOGFILE

VALIDATE $? "install mysql client"

mysql -h mysql.padmasrikanth.shop -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>$LOGFILE

VALIDATE $? "Load sql data"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "restart shipping "