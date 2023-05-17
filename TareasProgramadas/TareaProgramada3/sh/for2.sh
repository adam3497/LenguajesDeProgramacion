#!/bin/sh
# Here the for loop, loops through the options given and it stops when it runs out of options
for i in hello 1 * 2 goodbye
do
    echo "Looping ... i is set to $i"
done