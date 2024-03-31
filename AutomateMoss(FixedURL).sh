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

# Fixed percentage as criteria
percentage="80%"

# Output excel file name, put in by sequence [must have size equal to URL]
declare -a filename=("P1" "P2" "P3" "P4" "P5") 

# URL to curl data from [must have size equal to filename]
declare -a url=("http://moss.stanford.edu/results/4/1581003683126/"
				"http://moss.stanford.edu/results/4/9525196907083/"
				"http://moss.stanford.edu/results/8/8549465395949/"
				"http://moss.stanford.edu/results/3/263277211665/"
				"http://moss.stanford.edu/results/6/7890024688999/"
				)

amountoffile=$(echo ${#url[@]})
echo "Amount of URL : $amountoffile"

for ((i=0; i < $amountoffile; i++)); do
	echo -e "\nCurrently listing on file : ${filename[i]} ${url[i]}"

	result=$(curl -sS ${url[i]} | grep -Poiz '<table>.*(\n|.)*</table>' | sed '1d;2d;$d' | sed 's/\(<tr.*=\|<td.[^"]*=*[^",^0-9]\|  \+\|<\/a\>.$\)//ig' | sed 's/>../ "/ig' | sed -e '/(.*%)/s/$/"/')

	echo "" | sed "1 i\Moss results link : ,,\\${url[i]}\nCtrl+H (find and replace function) and replace '|' with <Comma Symbol> to make the Hyperlink work!\n\nAbove Criterion,,,,,,,,Below Criterion\nLine 1,Line 2,Percentage,Line Matched,,,,,Line 1,Line 2,Percentage,Line Matched" | sed '$d' > "Results of ${filename[i]%.*}".csv

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