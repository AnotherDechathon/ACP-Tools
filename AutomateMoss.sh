#!/bin/bash

# MIT License

# Copyright (c) 2023 AnotherDechathon

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

echo " ________________________________________________________________________________________ "
echo "|                                                                                        |"
echo "|               Welcome to AutomateMOSS powered by MOSS Standford University             |"
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
echo "|________________________________________________________________________________________|"
echo "|                                                                                        |"
echo "| How to use, the script read info about file inside of () that seperate by space        |"
echo "|     1. Compare single file that has the same name                                      |"
echo "|        Input format : (fileName languageType percentage%)                              |"
echo "|        Example      : (Test.java java 80%) (Source.ccp c 70%)                          |"
echo "|        Results      : file 1 Test.java                                                 |"
echo "|                       file 2 Source.ccp                                                |"
echo "|                                                                                        |"
echo "|     2. Compare single file that has different name but use same setting                |"
echo "|        Input format : (fileName1|...|fileName3 languageType percentage%)               |"
echo "|        Example      : (Test.java|Calculator.java|DiceGame.java java 70%)               |"
echo "|        Results      : file 1 Test.java java 70%                                        |"
echo "|                       file 2 Calculator.java java 70%                                  |"
echo "|                       file 3 DiceGame.java java 70%                                    |"
echo "|                                                                                        |"
echo "|     3. Compare between multiple file that has different name                           |"
echo "|        Input format : (fileName1,...,fileName3 languageType percentage%)               |"
echo "|        Example      : (Oop1.java,Oop2.java,Oop3.java java 80%)                         |"
echo "|        Results      : file 1 Oop1.java,Oop2.java,Oop3.java java 80%                    |"
echo "|________________________________________________________________________________________|"

# TEST FORMAT, NOTHING TO SEE HERE
# (filename1 languagetype1 50%) (filename2 languagetype2 60%) (filename3 languagetype3 70%)
# (filename1 languagetype1 50%) (filename2.1,filename2.2 languagetype2 60%) (filename3 languagetype3 70%)
# (SicBo.java|BasicStat.java java 50%) (SicBoV2.java,SicBoV3.java java 60%) (SicBoV4.java java 70%)
# (SicBoV3.java java 80%) (SicBoV4.java java 80%) (DisplayMatrix.java java 70%) (Athlete.java,Boxer.java,Footballer.java java 70%) (TestPolygons.java java 70%)
# (filename.fileformat languagetype percantage%)
# ('filename.fileformat filename.fileformat' languagetype percantage%)
# (*.fileformat languagetype percantage%)

declare -a filename=()
declare -a languagetype=()
declare -a percentage=()
file_regex="\(([^)]+%)\)"
amountoffile=1
arrayindex=0
insidearrayindex=0

read -rep $'\nEnter the name of the file you want to check : ' file_list

if (( $(echo "$file_list" | grep -o "(*%)" | wc -l) > 0 )); then
	echo -e "\nList of file"
	echo -e "____________________________________\n"
fi

while [[ $file_list =~ $file_regex ]]; do
	file_array+=("${BASH_REMATCH[1]}")
	file_list=${file_list#*"${BASH_REMATCH[1]}"}

	catagorize_array+=($(echo ${file_array[arrayindex]} | grep -oE '.* |.*%'))

	if [[ "${catagorize_array[insidearrayindex]}" == *"|"* ]]; then
		sy=$(($(echo "${catagorize_array[insidearrayindex]}" | grep -o "|" | wc -l)+1))
		listoffile=()
		listoffile+=(${catagorize_array[insidearrayindex]//|/ })

		for ((i=0; i < $sy; i++)); do
			filename+=($(echo ${listoffile[i]}))
			languagetype+=($(echo ${catagorize_array[insidearrayindex+1]}))
			percentage+=($(echo ${catagorize_array[insidearrayindex+2]}))

			let "amountoffile=amountoffile+1"
		done
	else
		filename+=($(echo ${catagorize_array[insidearrayindex]}))
		languagetype+=($(echo ${catagorize_array[insidearrayindex+1]}))
		percentage+=($(echo ${catagorize_array[insidearrayindex+2]}))

		let "amountoffile=amountoffile+1"
	fi

	let "arrayindex=arrayindex+1"
	let "insidearrayindex=insidearrayindex+3"
done

for ((print=0; print < $(echo ${#filename[@]}); print++)); do
	echo "File $((print+1))"
	echo "File name 		: ${filename[print]}"
	echo "Type of language 	: ${languagetype[print]}"
	echo "Criterion percentage 	: ${percentage[print]}"
done

echo -e "\n____________________________________\n\nThis process might take a while due to the processing of script (around 1-5 min per file). You should go get some coffee or take some rest.\n"

for ((i=0; i < $(echo ${#filename[@]}); i++)); do
	if [[ "${filename[i]}" == *","* ]]; then
		echo "Waiting for Moss"
		listoffile+=(${filename[i]//,/ })
		url=$((/usr/bin/find . -type f \( -name "${listoffile[0]}" $(printf -- '-o -name %s ' "${listoffile[@]:1}") \) -exec perl moss.pl -l ${languagetype[i]} {} +) | tail -1)/
	else
		echo "Waiting for Moss"
		url=$((/usr/bin/find . -name ${filename[i]} -exec perl moss.pl -l ${languagetype[i]} {} +) | tail -1)/
	fi

	# Fixed URL for testing purpose only
	# url="http://moss.stanford.edu/results/0/8933801114066/"

	echo "Currently checking on file $(($i+1)) : ${filename[i]}"
	echo "Url : $url"

	if [[ "$url" != "/" ]]; then 
		result=$(curl -sS $url | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*=\|<td.[^"]*=*[^",^0-9]\|  \+\|<\/a\>.$\)//ig' | sed 's/>../ "/ig' | sed -e '/(.*%)/s/$/"/')

		echo "" | sed "1 i\Moss results link : ,,\\$url\nCtrl+H (find and replace function) and replace '|' with <Comma Symbol> to make the Hyperlink work!\n\nAbove Criterion,,,,,,,,Below Criterion\nLine 1,Line 2,Percentage,Line Matched,,,,,Line 1,Line 2,Percentage,Line Matched" | sed '$d' > "Results of ${filename[i]%.*}".csv
		# echo "" | sed "1 i\Moss results link : ,,\\$url\nCtrl+H (find and replace function) and replace '|' with <Comma Symbol> to make the Hyperlink work! \nSorry to make you to replace <Comma> in hyperlink everytime but I dont know to to make .csv avoid <Comma> \n\nAbove Criterion" | sed '$d' > "Results of ${filename[i]%.*}".csv

		abovecriterion=$(echo "$result" | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | awk '/\([0-9]+%\)/ {match($0, /\(([0-9]|[1-9][0-9]|100)%\)/); if (+substr($0, RSTART+1, RLENGTH-3) >= '${percentage%?}') print}')
		belowcriterion=$(echo "$result" | sed 'N;N;s/\n\([^\n]*\)\n\([^\n]*\)/ \1 \2/g' | awk '/\([0-9]+%\)/ {match($0, /\(([0-9]|[1-9][0-9]|100)%\)/); if (+substr($0, RSTART+1, RLENGTH-3) < '${percentage%?}') print}')

		numberabovecriterion=$(echo "$abovecriterion" | grep -c .)
		numberbelowcriterion=$(echo "$belowcriterion" | grep -c .)

		if (( "$numberabovecriterion" > "$numberbelowcriterion" )); then
			for ((round=1; round <= $(($numberabovecriterion + $numberbelowcriterion)); round++)); do
				x=$(echo -e $(echo "$abovecriterion" | sed -n "${round}p")"\n"$(echo "$belowcriterion" | sed -n "${round}p"))
				echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | awk '!/".*"/{printf "%s%s",$0,NR%4?",":",,,,,";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename[i]%.*}".csv
				echo "" >> "Results of ${filename[i]%.*}".csv
				echo -n "."
			done
		else
			for ((round=1; round <= $numberabovecriterion; round++)); do
				x=$(echo -e $(echo "$abovecriterion" | sed -n "${round}p")"\n"$(echo "$belowcriterion" | sed -n "${round}p"))
				echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | awk '!/".*"/{printf "%s%s",$0,NR%4?",":",,,,,";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename[i]%.*}".csv
				echo "" >> "Results of ${filename[i]%.*}".csv
				echo -n "."
			done
			for ((round=$numberabovecriterion+1; round <= $numberbelowcriterion; round++)); do
				x=$(echo "$belowcriterion" | sed -n "${round}p")
				echo "$x" | awk '{gsub(/)" /,"&\n")}1' | sed 's/" "/"| "/ig' | awk '{print $1" "$2" "$3 "\n"substr($3,1,length($3)-1)}' | sed 'N;N;N;N;N;s/\([^\n]*\)\n\([^\n]*"\)\n\(.*\)\n/\2\n\1:\3/g' | sed "1 i\,,,,,,," | awk '!/".*"/{printf "%s%s",$0,",";}/".*"/{printf "=hyperlink(%s)%s",$0,",";}' >> "Results of ${filename[i]%.*}".csv
				echo "" >> "Results of ${filename[i]%.*}".csv
				echo -n "."
			done
		fi
	else
		echo "Failed on checking file $(($i+1)) : ${filename[i]}"
	fi
done

echo -e "\nDone! Are you still awake? I have a cat and some coffee prepared for you." 
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

read -rsn1 -p "Press any keys to exit"