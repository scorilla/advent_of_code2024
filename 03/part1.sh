#!/bin/bash
cat input.txt | sed 's/mul([0-9]*,[0-9]*)/&\n/g' | sed 's/mul([0-9]*,[0-9]*)/\n&/g' | grep "^mul([0-9]*,[0-9]*)$" | grep -Eo '[0-9]*,[0-9]*' | awk -F"," '{print $1"*"$2}' | bc | tr "\n" "+" | sed 's/.$//' | xargs -I {} echo {} | bc
