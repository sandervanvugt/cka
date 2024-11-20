if kubectl get pod securepod -n oklahoma -o yaml | grep 'serviceAccount: secure' &>/dev/null
then
	echo -e "\033[32m[OK]\033[0m\t\t pod securepod in namespace oklahoma found and it is using the serviceaccount secure"
	SCORE=$(( SCORE + 10 ))
else
	echo -e "\033[31m[FAIL]\033[0m\t\t couldn't find the pod securepod in namespace oklahoma that uses the serviceaccount secure"
fi
TOTAL=$(( TOTAL + 10 ))
