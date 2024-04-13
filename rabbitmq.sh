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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Downlaod erlan repo"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "Downlaod rabbitmq repo"

yum install rabbitmq-server -y &>>$LOGFILE

VALIDATE $? "Install rabbitmq"

systemctl enable rabbitmq-server &>>$LOGFILE

VALIDATE $? "enable rabbitmq"

systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "start rabbitmq"

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "add rabbitmq user and pass"

rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "set permisssion"