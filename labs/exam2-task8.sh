if kubectl get svc lab168svc | grep NodePort &>/dev/null 
then
        echo -e "\033[32m[OK]\033[0m\t\t The NodePort Service lab168svc was found"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t The NodePort Service lab168svc was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl describe ing lab168pod | grep '/hi.*lab168pod:80 ..*)' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t an ingress resource was found and it does have pod endpoints"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t no ingress resource with pod endpoints was found"
fi
TOTAL=$(( TOTAL + 10 ))
