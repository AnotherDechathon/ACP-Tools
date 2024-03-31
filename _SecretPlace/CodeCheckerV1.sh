#!/bin/bash

# Currently supported languages
# 'c', 'cc', 'java', 'ml', 'pascal', 'ada', 'lisp', 'scheme', 'haskell' 
# 'fortran', 'ascii', 'vhdl', 'perl', 'matlab', 'python', 'mips', 'prolog'
# 'spice', 'vb', 'csharp', 'modula2', 'a8086', 'javascript', 'plsql', 'verilog'

# ! CHANGE FILE FORMAT BELOW TO MATCH THE FILE YOU WANT TO CHECK  !
fileformat=".java"

#tput rmam

echo "|========================================================================================|"
echo "|   Welcome to MOSS, A System for Detecting Software Similarity by Stanford University   |"
echo "|      For more information, please visit : https://theory.stanford.edu/~aiken/moss/     |"
echo "|========================================================================================|"
echo "| Currently supported languages                                                          |" 
echo "|   'c', 'cc', 'java', 'ml', 'pascal', 'ada', 'lisp', 'scheme', 'haskell',               |"
echo "|   'fortran', 'ascii', 'vhdl', 'perl', 'matlab', 'python', 'mips', 'prolog'             |"
echo "|   'spice', 'vb', 'csharp', 'modula2', 'a8086', 'javascript', 'plsql', 'verilog         |"
echo "|========================================================================================|"

read -rep  $'\nEnter the name of the file you want to check (without format) : ' filename
read -rep  $'Which language is it (Select from above) : ' fileformat

echo "Checking on file : $filename.$fileformat"

#case $choice in  
#	1) 
#	2) 
#	*) 
#esac












#echo -e "\nChecking on file : $filename.$fileformat\n"

#getname="$(basename "$0" .sh)$fileformat"
#echo "Checking on file : $getname"

#echo -e 'Press '1' to export results into .csv \nPress '2' to view raw data in terminal'
#read -p "Make your decision : " choice

#case $choice in  
#	1) echo -e "\n=====================================\n"
#	   echo -e "This process take a while, you should go get some coffee.\n"
#	   url=$((/usr/bin/find . -name $getname -exec perl moss.pl {} +) | tail -1 )/
#	   curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|  \+\|<\/a\>.$\)//ig' | sed '1 i\Line_1\nLine_2\nLine_Matched' | awk '{printf "%s%s",$0,NR%3?",":"\n" ; }' > raw.csv
#	   ;; 
#	2) echo -e "\n=====================================\n"
#	   echo -e "This process take a while, you should go get some coffee.\n" 
#	   url=$((/usr/bin/find . -name $getname -exec perl moss.pl {} +) | tail -1 )/
#	   curl -sS $url | grep -Poiz "<table>.*(\n|.)*</table>" | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|<\/a\>.$\)//ig' | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | column -t 
#	   ;; 
#	*) echo -e "\n====================================="
#	   echo -e "\nIndecisive person, Huh? I don't care, get this.\n" 
#	   url=$((/usr/bin/find . -name $getname -exec perl moss.pl {} +) | tail -1 )/
#	   curl -sS $url | grep -Poiz "<table>.*(\n|.)*</table>" | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|<\/a\>.$\)//ig' | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | column -t
#	   ;; 
#esac
#
#echo -e "\nDone! Are you still awake?\n"
read -rsn1 -p "Press any key to exit"