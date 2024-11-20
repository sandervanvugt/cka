echo evaluating task 1

if [[ $(echo $(kubectl get nodes | grep control | wc -l)) == 3 ]] &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t 3 control nodes were found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t 3 control nodes were not found"
fi
TOTAL=$(( TOTAL + 10 ))

if [[ $(echo $(kubectl get nodes | grep Ready | wc -l)) == 5 ]] &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t a total of 5 nodes was found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t couldn't find a total of 5 nodes"
fi
TOTAL=$(( TOTAL + 10 ))

