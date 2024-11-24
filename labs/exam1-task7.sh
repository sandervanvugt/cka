if kubectl get quota -n limited | grep 'memory: .*/1G' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t memory quota was set up correctly"
	SCORE=$(( SCORE + 5 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t memory quota was not set up correctly"
fi
TOTAL=$(( TOTAL + 5 ))

if kubectl get quota -n limited | grep 'pods: .*/5' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t Pods quota setup correctly"
        SCORE=$(( SCORE + 5 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t Pods quota no setup correctly"
fi
TOTAL=$(( TOTAL + 5 ))

if kubectl get deploy -n limited lab157deploy -o yaml | grep -A 5 resources | grep 'memory: 32Mi' &>/dev/null
then
        echo -e "\033[32m[OK]\033[0m\t\t lab157deploy resource request is set to 32 Mi"
        SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t lab157deploy resource request is not set to 32Mi"
fi
TOTAL=$(( TOTAL + 10 ))
