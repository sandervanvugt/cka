if kubectl describe node worker2 | grep NodeNotSchedulable &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Node was successfully drained" 
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t Cannot find any node drain events in the node logs"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl get nodes | grep SchedulingDisabled
then
        echo -e "\033[31m[FAIL]\033[0m\t\t Node was not reset to normal operational state"
else
        echo -e "\033[32m[OK]\033[0m\2t\t Node worker2 was reset to normal operational state" 
        SCORE=$(( SCORE + 10 ))
fi
TOTAL=$(( TOTAL + 10 ))
