if kubectl get pods | grep lab159pod-worker2 &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t NetworkPolicy was found with correct configuration"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t No NetworkPolicy with correct configuration was found"
fi
TOTAL=$(( TOTAL + 10 ))

