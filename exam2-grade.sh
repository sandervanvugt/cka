#!/bin/bash
# exit if not root
clear
# evaluating tasks
echo -e "\033[1mchecking task 1 results\033[0m"
source labs/exam2-task1.sh
echo the score is $SCORE
TOTALSCORE=$SCORE
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 2 results\033[0m"
source labs/exam2-task2.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 3 results\033[0m"
source labs/exam2-task3.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 4 results\033[0m"
source labs/exam2-task4.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 5 results\033[0m"
source labs/exam2-task5.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 6 results\033[0m"
source labs/exam2-task6.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 7 results\033[0m"
source labs/exam2-task7.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 8 results\033[0m"
source labs/exam2-task8.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 9 results\033[0m"
source labs/exam2-task9.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 10 results\033[0m"
source labs/exam2-task10.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

echo -e "\033[1mchecking task 11 results\033[0m"
source labs/exam2-task11.sh
echo the score is $SCORE
TOTALSCORE=$(( TOTAL + SCORE ))
TOTALTOTAL=$TOTAL

#### print PASS/FAIL
echo -e "\n"
echo your score is $SCORE out of a total of $TOTAL

if [[ $SCORE -ge $(( TOTAL / 10 * 7 )) ]]
then
        echo -e "\033[32mCONGRATULATIONS!!\033[0m\t\t You passed this sample exam!"
	echo -e "\033[1mResults obtained here don't guarantee anything for the real exam\033[0m"
else
        echo -e "\033[31m[FAIL]\033[0m\t\t You did NOT pass this sample exam \033[36m:-(\033[0m"
fi

