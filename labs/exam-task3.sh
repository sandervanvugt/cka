if kubectl get cm task3cm -o yaml |grep index.html &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t a configmap with the name task3cm was found with the right contents"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t configmap with the name task3cm was not found"
fi
TOTAL=$(( TOTAL + 10 ))

if kubectl describe pod oregonpod | grep -A1 'ConfigMap' | grep task3cm &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t the pod oregonpod has the configmap task3cm mounted"
	SCORE=$(( SCORE + 10 ))
else
        echo -e "\033[31m[FAIL]\033[0m\t\t the pod oregonpod doesn't seem to have the configmap task3cm mounted"
fi
TOTAL=$(( TOTAL + 10 ))
