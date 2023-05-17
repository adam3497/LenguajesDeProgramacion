#!/bin/sh
# A simple script with a function...

add_a_user()
{
    USER=$1
    PASSWORD=$2
    shift; shift;
    # Having shifted twice, ther rest is now comments...
    COMMENTS=$@
    echo "Adding user $USER ..."
    echo useradd -C "$COMMENTS" $USER
    echo passwd $USER $PASSWORD
    echo "Added user $USER ($COMMENTS) with password $PASSWORD"
}

###
# Main body of script starts here
###

echo "Start of the script..."
add_a_user bob letmein Bob Holness the presenter
add_a_user fred baddpassword Fred Durst the singer
add_a_user bilko worsepassword Sgt. Bilko the role model
echo "End of the script..."