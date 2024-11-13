if kubectl describe networkpolicy | grep 'PodSelector:.*type=webapp' &>/dev/null && kubectl describe networkpolicy | grep 'PodSelector:.*type=tester' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t NetworkPolicy was found with correct configuration"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t No NetworkPolicy with correct configuration was found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl exec -it nevatest -- wget --spider --timeout=1 nevaginx &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t the tester pod can access the nevaginx pod"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the tester pod cannot access the nevaginx pod"
fi
TOTAL=$(( TOTAL + 10 ))
