#!/bin/bash

function ex1 {
clear
echo "C которого IP было больше всего запросов"
awk ' {print $1} ' $1 |sort|uniq -c  |awk -v max=0 '{if($1>max){want=$2; max=$1}}END{print want} '
}

function ex2 {
clear
echo "Часто запрашиваемая страница"
awk ' {print $7} ' $1 | grep "^/[a-z]" |sort | uniq -c |awk -v max=0 '{if($1>max){want=$2; max=$1}}END{print want} '
}

function ex3 {
clear
echo "Количество запросов с каждого IP"
awk ' {print $1} ' $1 |sort | uniq -c |sort -n -k 1
}

function ex4 {
clear
echo "Список запросов к несуществующим страницам"
awk ' {print $9,$7} ' $1 | grep "^404" |sort | uniq -c |sort -n -k 1
}

function ex5 {
clear
echo "Пик запросов"
awk ' {print $4} ' $1 | awk -F: ' {print $2} ' | sort |uniq -c |awk -v max=0 '{if($1>max){want=$2; max=$1}}END{print want} ' 
}

function ex6 {
clear
echo "Поисковые боты (UA+IP)"
awk -F "\"" ' {if ($6~/[Bb]ot/){$2 = $3 = $4 = $5 = "0"; print $0}} ' $1| awk ' {print $10, $1} ' | sort -k 2 | uniq -c | sort -rn -k 1
}


echo -e  \
" 1: IP с которого было больше всего запросов; \n" \
"2: Часто запрашиваемая страница; \n" \
"3: Количество запросов с каждого IP; \n" \
"4: Список запросов к несуществующим страницам\n" \
"5: В какое время было пик запросов \n" \
"6: Поисковые боты (UA+IP)\n" \

read -n 1 answer
echo -e "\n"
case "$answer" in

1 ) ex1 $1;;
2 ) ex2 $1;;
3 ) ex3 $1;;
4 ) ex4 $1;;
5 ) ex5 $1;;
6 ) ex6 $1;;
esac
