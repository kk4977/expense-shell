#!/bin/bash
USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

echo "Please enter DB password:"
read -s mysql_root_password

VALIDATE(){
   if [ $1 -ne 0 ]
   then
        echo -e "$2...$R FAILURE $N"
        exit 1
    else
        echo -e "$2...$G SUCCESS $N"
    fi
}

if [ $USERID -ne 0 ]
then
    echo "Please run this script with root access."
    exit 1 # manually exit if error comes.
else
    echo "You are super user."
fi

dnf module disable nodejs  -y &>>$LOGFILE 
VALIDATE $? "Disabling Default NodeJS"

dnf module enable nodejs:20 -y &>>$LOGFILE 
VALIDATE $? "Enabling NodeJS 20 Version"

dnf install nodejs -y &>>$LOGFILE 
VALIDATE $? "Installing NodeJS 20 Version"

id expense &>>$LOGFILE

if [ $? -ne 0 ]
then 
    useradd expense 
    VALIDATE $? "Creating expense user"
else 
    echo "expense user already exists...$y SKIPPING $N"
fi

mkdir /app &>>$LOGFILE
VALIDATE $? "Creating App directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOGFILE
VALIDATE $? "Downloading  App directory"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOGFILE 
VALIDATE $? "Extracted backend code"

npm install &>>$LOGFILE
VALIDATE $? "Installed backend dependencies"

systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reloaded systemd"

systemctl start backend &>>$LOGFILE
VALIDATE $? "Started backend"

systemctl enable backend &>>$LOGFILE
VALIDATE $? "Enabled backend"


dnf install mysql -y &>>$LOGFILE
VALIDATE $? "Installing MySQL Client"

mysql -h db.sivakumar.cloud -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>$LOGFILE
VALIDATE $? "Schema is Loading"

systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting backend"



