if kubectl get pods sidepod -o yaml | grep -A 10  initContainers | grep 'restartPolicy: Always' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t found a pod sidepod that runs a sidecar container"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t didn't find a pod sidepod that runs a sidecar container"
fi
TOTAL=$(( TOTAL + 10 ))
