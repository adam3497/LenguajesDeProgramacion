#!/bin/sh
echo "What is your name?"
read USER_NAME
echo "Hello $USER_NAME"
# By using ${variable_name} you can access the variable and then attached something else to the name 
echo "I will create you a file called ${USER_NAME}_file"
touch ${USER_NAME}_file