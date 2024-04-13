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

yum module disable mysql -y &>>$LOGFILE

VALIDATE $? "Disable mysql"

cp -rp /home/centos/roboshopshell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE

VALIDATE $? "copy repo"

yum install mysql-community-server -y &>>$LOGFILE

VALIDATE $? "Install Mysql community"

systemctl enable mysqld &>>$LOGFILE

VALIDATE $? "enable mysql"

systemctl start mysqld &>>$LOGFILE

VALIDATE $? "start mysql"

mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE

VALIDATE $? "restart password"

mysql -uroot -pRoboShop@1 &>>$LOGFILE

VALIDATE $? "mysql connect"
