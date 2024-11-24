if kubectl get pods | grep lab158pod-worker2 &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Static Pod was found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t Static Pod was not found"
fi
TOTAL=$(( TOTAL + 10 ))

