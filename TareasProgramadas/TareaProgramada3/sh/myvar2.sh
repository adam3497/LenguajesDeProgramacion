#!/bin/sh
# with export MYVAR we can make a variable visible to other bash enviroments
# to make the changes of our file be noticed to the other enviroments, we use . ./myfile.sh 
echo "MYVAR is: $MYVAR"
MYVAR="hi there"
echo "MYVAR is: $MYVAR"