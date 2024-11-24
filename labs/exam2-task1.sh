if [[ $(echo $(kubectl get nodes |  grep Ready | wc -l)) == 3 ]] &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t 3 nodes were found"
        SCORE=$(( SCORE + 20 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t 3nodes were not found"
fi
TOTAL=$(( TOTAL + 20 ))
