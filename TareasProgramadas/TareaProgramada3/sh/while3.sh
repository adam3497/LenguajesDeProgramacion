#!/bin/sh
# With this while we read all the lines from a file, compare each line with a case and print the language
while read input_text
do
    case $input_text in
        hello)              echo English    ;;
        howdy)              echo American   ;;
        gday)               echo Australian ;;
        bonjour)            echo French     ;;
        "guten tag")        echo German     ;;
        hola)               echo Spanish    ;;
        *)                  echo Unknown Language: $input_text  ;;
    esac
done < myfile.txt