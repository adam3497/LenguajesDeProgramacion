#!/bin/sh

# Sintaxys of if..then..else
if [ ... ]
then
    # if-code
else 
    # else-code
fi 

# Alternative 
if [ ... ]; then
    # do something
fi

# elif
if [ ... ]; then
    echo "Something"
elif [ something_else ]; then
    echo "Something else"
else
    echo "None of the above"
fi

