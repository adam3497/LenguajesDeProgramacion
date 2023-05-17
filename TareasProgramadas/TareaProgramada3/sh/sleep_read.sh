#!/bin/sh

trap 'stty "$(stty -g)"' EXIT
stty -icanon -echo min 0 time 100 # 10*10

read -p "Enter your input >>> " input

if [ -z "$input" ]; then
  echo "No input provided"
else
  echo "You entered: $input"
fi
