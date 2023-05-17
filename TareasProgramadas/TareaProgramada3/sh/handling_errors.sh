#!/bin/sh
echo -en "Please guess the magic number: "
read USER_INPUT
echo $USER_INPUT | grep "[^0-9]" > /dev/null 2>&1
if [ "$?" -eq "0" ]; then
    # If the grep found something other than 0-9 
    # then it's not an integer.
    echo "Sorry, wanted a number"
else
    # The grep found only 0-9, so it's an integer.
    # We can safely do a test on it.
    if [ "$USER_INPUT" -eq "7" ]; then
        echo "You entered  the magic number! :D"
    else
        echo "Sorry, that's not the magic number :("
    fi
fi 