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

# url="http://moss.stanford.edu/results/9/6431545965346/"
url=$((/usr/bin/find . -name $filename -exec perl moss.pl -l $languagetype {} +) | tail -1)/
result=$(curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*=\|<td.[^"]*=*[^",^0-9]\|  \+\|<\/a\>.$\)//ig' | sed 's/>../ "/ig' | sed -e '/(.*%)/s/$/"/')

read -p 'Do you want to specify the percentage of the similarity of code? [Y/N] ' criterion

shopt -s nocasematch

case $criterion in
	Y)
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
 		;;
esac

# filename="SicBo.java"
# criterion="y"
# percentage="20%"
# choice="1"

echo -e "\nPress '1' to export results into .csv file\nPress '2' to view raw results in terminal"
read -p 'Make your decision : ' choice

case $choice in  
	1)
		if [[ "$criterion" == "Y" ]]; then
			abovecriterion=$(echo "$result" | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | awk '/\([0-9]+%\)/ {match($0, /\(([0-9]|[1-9][0-9]|100)%\)/); if (+substr($0, RSTART+1, RLENGTH-3) >= '${percentage%?}') print}')
			belowcriterion=$(echo "$result" | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | awk '/\([0-9]+%\)/ {match($0, /\(([0-9]|[1-9][0-9]|100)%\)/); if (+substr($0, RSTART+1, RLENGTH-3) < '${percentage%?}') print}')

			numberabovecriterion=$(echo "$abovecriterion" | grep -c .)
			numberbelowcriterion=$(echo "$belowcriterion" | grep -c .)

			echo "" | sed "1 i\Moss results link : ,,\\$url\nCtrl+H (find and replace function) and replace '|' with <Comma Symbol> to make the Hyperlink work! \nSorry to make you to replace <Comma> in hyperlink everytime but I dont know to to make .csv avoid <Comma> \n\nAbove Criterion,,,,,,,,Below Criterion\nLine 1,Line 2,Percentage,Line Matched,,,,,Line 1,Line 2,Percentage,Line Matched" | sed '$d' > "Results of ${filename%.*}".csv

			if (( "$numberabovecriterion" > "$numberbelowcriterion" )); then
				for ((i=1; i <= $(($numberabovecriterion + $numberbelowcriterion)); i++)); do
					x=$(echo -e $(echo "$abovecriterion" | sed -n "${i}p")"\n"$(echo "$belowcriterion" | sed -n "${i}p"))
					echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | awk '!/".*"/{printf "%s%s",$0,NR%4?",":",,,,,";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename%.*}".csv
					echo "" >> "Results of ${filename%.*}".csv
				done
			else 
				for ((i=1; i <= $numberabovecriterion; i++)); do
					x=$(echo -e $(echo "$abovecriterion" | sed -n "${i}p")"\n"$(echo "$belowcriterion" | sed -n "${i}p"))
					echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | awk '!/".*"/{printf "%s%s",$0,NR%4?",":",,,,,";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename%.*}".csv
					echo "" >> "Results of ${filename%.*}".csv
				done
				for ((i=$numberabovecriterion+1; i <= $numberbelowcriterion; i++)); do
					x=$(echo "$belowcriterion" | sed -n "${i}p")
					echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | sed "1 i\,,,,,,," | awk '!/".*"/{printf "%s%s",$0,",";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename%.*}".csv
					echo "" >> "Results of ${filename%.*}".csv
				done
			fi
		fi
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

read -rsn1 -p "Press any keys to exit"