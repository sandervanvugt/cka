if [[ $(kubectl get hpa | awk '/lab1610deploy/ { print $5 }') == 2 ]] && [[ $(kubectl get hpa | awk '/lab1610deploy/ { print $6 }') == 6 ]]
then
	echo -e "\033[32m[OK]\033[0m\t\t found a correctly configured HPA"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t didn't find a correctly configured HPA"
fi
TOTAL=$(( TOTAL + 10 ))
