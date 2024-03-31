#!/bin/bash

# MIT License

# Copyright (c) 2023 NorthWest

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

echo " ________________________________________________________________________________________"
echo "|                                                                                        |"
echo "|   Welcome to MOSS, A System for Detecting Software Similarity by Stanford University   |"
echo "|      For more information, please visit : https://theory.stanford.edu/~aiken/moss/     |"
echo "|________________________________________________________________________________________|"
echo "|                                                                                        |"
echo "| Currently supported languages                                                          |"
echo "|   C, C++, Java, C#, Python, Visual Basic, Javascript, FORTRAN                          |"
echo "|   ML, Haskell, Lisp, Scheme, Pascal, Modula2, Ada, Perl, TCL                           |"
echo "|   Matlab, VHDL, Verilog, Spice, MIPS assembly, a8086 assembly, HCL2                    |"
echo "|                                                                                        |"
echo "| Type of language setting for MOSS to check                                             |"
echo "|   'c', 'cc', 'java', 'ml', 'pascal', 'ada', 'lisp', 'scheme', 'haskell'                |"
echo "|   'fortran', 'ascii', 'vhdl', 'perl', 'matlab', 'python', 'mips', 'prolog'             |"
echo "|   'spice', 'vb', 'csharp', 'modula2', 'a8086', 'javascript', 'plsql', 'verilog'        |"
echo "|                                                                                        |"
echo "|________________________________________________________________________________________|"

read -rep $'\nEnter the name of the file you want to check (With file format, you can use *.fileformat) : ' filename
read -rep $'Which type of language is it (Select from above) : ' languagetype

echo -e "\nChecking on file \"$filename\""
echo -e "This process might take a while due to the processing of MOSS. You should go get some coffee or take some rest.\n"

url=$((/usr/bin/find . -name $filename -exec perl moss.pl -l $languagetype {} +) | tail -1 )/
result=$(curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*=\|<td.[^"]*=*[^",^0-9]\|  \+\|<\/a\>.$\)//ig' | sed 's/>../ "/ig' | sed -e '/(.*%)/s/$/"/')

echo $url
#result=$(curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|  \+\|<\/a\>.$\)//ig' | sed '1 i\Line_1\nLine_2\nLine_Matched')
#echo "$result"

read -p 'Do you want to specify the percentage of the similarity of code? [Y/N] ' criterion

case $criterion in
	y|Y)
		echo " ________________________________________________________________________________________ "
		echo "| How to use this function                                                               |"
		echo "|   After you entered the percentage that you want as a criterion, the program will      |"
		echo "|   bring the persons that exceeds the percentage to the top with a list of others below |"
		echo "|                                                                                        |"		
		echo "|   Example of input : 80%                                                               |"		
		echo "|________________________________________________________________________________________|"
		read -rep $'\nHow percentage you want to consider as copying each other code : ' percentage
 		;;
	  *)
		percentage="0% -A"
 		;;
esac

# echo $percentage

echo -e "\nPress '1' to export results into .csv file\nPress '2' to view raw results in terminal"
read -p 'Make your decision : ' choice


case $choice in  
	1)
		echo "$result" | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | sed "1 i\Moss results link : \n\n\\$url\n\n\Ctrl+H (find and replace function) and replace '|' with <Comma Symbol> to make the Hyperlink work! \n\n\n\n\Sorry to make you to replace <Comma> in hyperlink everytime but I dont know to to make .csv avoid <Comma> \n\n\n\n\n\n\n\nLine 1\nLine 2\nPercentage\nLine Matched" | awk '!/".*"/{printf "%s%s",$0,NR%4?",":"\n";}/".*"/{printf "=hyperlink(%s)%s",$0,NR%4?",":"\n";}' > "Results of ${filename%.*}".csv
		echo -e "\nDone! Are you still awake?\n"
		;;
	2) 
		echo "$result" | sed 's/\(".[^"]*".\|"\)//ig' | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g'
		echo -e "\nHere you are, the results, better go fullscreen to see all of it without any problem, or just choose option '1'\n"
		;;
	*) 
		echo -e "\nPress the wrong button or just hesitate? I don't know, but I have a cat and some coffee prepared for you." 
		echo '             ＿＿＿					'
		echo '           ／＞　  フ					'
		echo ' 　　　　　|  　　 |					'
		echo '　 　　 　／`ミ＿xノ	   ＿|二二二二二|   	'									
		echo ' 　　 　 /　　　  |	 ／＿|          |  	'
		echo ' 　　　 /　 ヽ　 ノ	 ||  |          | 	'
		echo ' 　 　 │　 ヽヽ  ﾉ	 ||＿|          | 	'
		echo ' 　／￣|　　| |  |	 ＼＿|          |	'
		echo ' 　| (￣ヽ＿ヽ)__) 	     ＼＿＿＿＿／ 	'
		echo ' 　＼二つ								'
		echo '                                      '
	   	;;
esac

# case $choice in
# 	1)
# 		echo -e "\n=====================================\n"
# 		echo -e "This process might take a while, you should go get some coffee.\n"
# 		url=$((/usr/bin/find . -name $filename -exec perl moss.pl {} +) | tail -1 )/
# 		curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|  \+\|<\/a\>.$\)//ig' | sed '1 i\Line_1\nLine_2\nLine_Matched' | awk '{printf "%s%s",$0,NR%3?",":"\n" ; }' > raw.csv
# 		echo -e "\nDone! Are you still awake?\n"
# 		;;
# 	2) 
# 		echo -e "\n=====================================\n"
# 		echo -e "This process might take a while, you should go get some coffee.\n" 
# 		url=$((/usr/bin/find . -name $filename -exec perl moss.pl {} +) | tail -1 )/
# 		curl -sS $url | grep -Poiz "<table>.*(\n|.)*</table>" | sed '1d;2d;$d' | sed 's/\(<tr.*[^>]*>..\|<td.[^>]*>*[^S,^0-9]*\|  \+\|<\/a\>.$\)//ig' | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | column -t 
# 		echo -e "\nDone! Are you still awake?\n"
# 		;;
# esac

read -rsn1 -p "Press any keys to exit"

# 			  ＿＿
# 　　　　　／＞　　フ
# 　　　　　|  　　 |
# 　 　　　／` ミ＿xノ      ＿|二二二二二|  
# 　　 　 /　　　  |    ／＿|          | 
# 　　　 /　 ヽ　  ノ    ||  |          | 
# 　 　 │　 | |  ﾉ     ||＿|          | 
# 　／￣|　　| | |      ＼＿|          |
# 　| (￣ヽ＿ヽ)__)　	       ＼＿＿＿＿／ 

# 　＼二つ

