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

yum install nginx -y &>>$LOGFILE

VALIDATE $? "Install Nginx"

systemctl enable nginx &>>$LOGFILE

VALIDATE $? "Enable Nginx"

systemctl start nginx &>>$LOGFILE

VALIDATE $? "start Nginx"

rm -rf /usr/share/nginx/html/* &>>$LOGFILE

VALIDATE $? "remove content of nginx"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>$LOGFILE

VALIDATE $? "copy source code of nginx"

cd /usr/share/nginx/html &>>$LOGFILE

VALIDATE $? "switch  nginx"
 
unzip /tmp/web.zip &>>$LOGFILE

VALIDATE $? "unzip nginx"

cp -rp /home/centos/roboshopshell/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>$LOGFILE

VALIDATE $? "copy roboshop.conf"

systemctl restart nginx  &>>$LOGFILE

VALIDATE $? "restart nginx"

